module SpotlightHelper

  def interval_for(item)
    case item.kind
    when 'event'
      result = []
      start = I18n.l(Date.parse(item.starts_on), :format => :long)
      finish = I18n.l(Date.parse(item.ends_on), :format => :long)

      if start.split.third == finish.split.third
        result << start.split.third
      else
        return "#{start} &ndash; #{finish}".html_safe
      end

      if start.split.second == finish.split.second
        result << start.split.second
      else
        return "#{start} &ndash; #{finish}".html_safe
      end

      if start.split.first == finish.split.first
        return start
      else
        result << "#{start.split.first} &ndash; #{finish.split.first}".html_safe
      end

      return result.reverse.join(' ').html_safe
    end
  end

end
