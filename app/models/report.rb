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

  attr_accessor :field_values
  attr_reader :results

  validates :defaults, :yaml => true

  after_initialize do
    @results = nil
    @field_values = {}
  end

  def field_values=(h)
    @field_values = h || {}
  end

  def execute
    return if needs_more_data?
    @results = db.fetch sql_query_with_params(@field_values)
  end

  def needs_more_data?
    report_fields.any? { |k| @field_values[k].blank? }
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
end
