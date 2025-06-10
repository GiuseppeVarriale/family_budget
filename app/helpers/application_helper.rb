module ApplicationHelper
  def formatted_month_year(date = Date.current)
    I18n.l(date, format: '%B %Y').capitalize
  end

  def formatted_date(date, format = :default)
    return '' if date.blank?

    I18n.l(date, format: format)
  end

  def formatted_datetime(datetime, format = :short)
    return '' if datetime.blank?

    I18n.l(datetime, format: format)
  end

  def current_month_name
    I18n.l(Date.current, format: '%B').capitalize
  end

  def current_year
    Date.current.year
  end
end
