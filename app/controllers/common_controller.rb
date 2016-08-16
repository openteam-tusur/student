class CommonController < ActionController::Base

  protect_from_forgery :with => :exception

  rescue_from ActionView::MissingTemplate, Encoding::UndefinedConversionError do |exception|
    raise ActionController::RoutingError.new('Not Found')
  end if Rails.env.production?
end
