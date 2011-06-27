class Report < ActiveRecord::Base
  def db; DB end

  def db; self.class.db end

  def execute(params = {})
    db.fetch sql_query_with_params(params)
  end

  def sql_query_with_params(params = {})
    q = sql_query.dup
    params.each { |k,v| q.gsub! field_regexp(k), "#{v}" }
    q
  end

  def report_fields
    return [] if sql_query.blank?
    sql_query.scan(field_regexp).flatten.collect {|f| f.strip.to_sym }.uniq
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
