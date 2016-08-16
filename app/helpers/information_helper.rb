module InformationHelper
  def address(building, office)
    address = building.try(:address)

    return '' unless address.present?

    content = []
    content << address
    content << "каб. #{office}" if office && office.is_a?(String)
    content << office.map{ |o| "каб. #{o}" }.join(', ') if office && office.is_a?(Array)

    content = content_tag :p do
      content_tag(:strong, I18n.t('address')) +
      content.join(', ')
    end

    content.html_safe
  end

  def municipal_phone(phone)
    return nil unless phone.kind == 'municipal'

    "(#{phone.code})&nbsp;#{phone.number.gsub(/(\d{2})(\d{2})(\d{2})/, '\1-\2-\3')}"
  end

  def internal_phone(phone)
    return nil unless phone.kind == 'internal'

    "внутр.&nbsp;#{phone.number}"
  end

  def phones(phones)
    return '' unless phones.present?

    phones_array = phones.sort{ |a, b| b.kind <=> a.kind }.inject([]) do |arr, phone|
      arr.push(municipal_phone(phone))
      arr.push(internal_phone(phone))
    end

    content = content_tag :p do
      content_tag(:strong, I18n.t('phone')) +
        phones_array.compact.join(', ').html_safe
    end

    content.html_safe
  end

  def emails(emails)
    return '' unless emails.present?

    content = content_tag :p do
      content_tag(:strong, I18n.t('emails')) +
      emails.map { |m| mail_to m.email}.join(', ').html_safe
    end

    content
  end

  def working_hours(working_hours)
    return '' unless working_hours.present?

    content = content_tag :p do
      content_tag(:strong, I18n.t('working_hours')) +
      working_hours
    end

    content.html_safe
  end

  def additional_info(additional_info)
    return '' unless additional_info.present?

    content = []
    additional_info.each do |info|
      content << content_tag(:p) do
        content_tag(:strong, I18n.t("additional_info.#{info.kind}")) +
        info.value
      end
    end

    content.join.html_safe
  end

end
