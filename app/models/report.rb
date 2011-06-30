class Report < ActiveRecord::Base
  def self.db; DB end
  def db; self.class.db end

  class YamlValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      begin
        YAML.parse(value)
      rescue Psych::SyntaxError
        record.errors[attribute] << (options[:message] || "is not valid YAML")
      end
    end
  end

  belongs_to :organization

  attr_accessor :field_values
  attr_reader :results

  validates :name, :presence => true
  validates :sql_query, :presence => true
  validates :defaults, :yaml => true
  validates_associated :organization

  after_initialize do
    @results = nil
    @field_values = {}
  end

  def self.find_and_execute(id, field_values)
    report = find(id)
    report.field_values = field_values
    report.execute
    report
  end

  def field_values=(h)
    @field_values = h || {}
  end

  def execute
    return if needs_more_data?
    @results = db.fetch sql_query_with_params(report_fields_with_values)
  end

  def needs_more_data?
    report_fields.any? { |k| report_fields_with_values[k].blank? }
  end

  def sql_query_with_params(params)
    params ||= {}
    q = sql_query.dup
    params.each { |k,v| q.gsub! field_regexp(k), "#{v}" }
    q
  end

  def report_fields
    return [] if sql_query.blank?
    sql_query.scan(field_regexp).flatten.collect {|f| f.strip.to_sym }.uniq
  end

  def report_fields_with_values
    fields = HashWithIndifferentAccess.new(parsed_defaults || {})
    report_fields.each { |f| fields[f] = @field_values[f] || fields[f] || '' }
    fields.each { |f,v| fields[f] = parse_date(v) if sounds_like_a_date? f }
    fields
  end

  def to_csv
    return "" if needs_more_data?
    @results.to_csv
  end

private
  def field_regexp(for_field = nil)
    if for_field
      /<% *#{for_field} *%>/
    else
      /<%(.+?)%>/
    end
  end

  def parsed_defaults
    return {} if defaults.blank?
    parsed = YAML.load defaults
    raise "Invalid defaults string" unless parsed.is_a? Hash
    parsed
  end

  def sounds_like_a_date?(field)
    field.to_s.match(/date|time/i)
  end

  def parse_date(value)
    begin
      Date.parse(value).to_date.to_s(:db)
    rescue ArgumentError
      nil
    end
  end
end
