class Report < ActiveRecord::Base
  def self.db; DB end
  def db; self.class.db end

  attr_accessor :field_values
  attr_reader :results

  def after_initialize
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
    fields = HashWithIndifferentAccess.new(@field_values || {})
    report_fields.each { |f| fields[f] ||= '' }
    fields
  end

private
  def field_regexp(for_field = nil)
    if for_field
      /<% *#{for_field} *%>/
    else
      /<%(.+?)%>/
    end
  end
end
