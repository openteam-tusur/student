class User

  include AuthClient::User
  include TusurHeader::MenuLinks

  acts_as_auth_client_user

  def app_name
    'postgraduate'
  end

  def available_permissions
    @available_permissions ||= permissions.pluck(:role)
  end

  def has_any_permissions?
    available_permissions.any?
  end

  def available_contexts
    permissions.where(role: 'clerk').map(&:context)
  end

end
