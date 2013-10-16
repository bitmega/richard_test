class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :check_subdomain

  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = exception.message
    if request.format.json?
      render :json => {success: false}, :status => 403
    else
      redirect_to root_url
    end
  end

  protected
  def check_subdomain
    return if Rails.env.test?
    if current_user
      if request.subdomain.blank? || request.subdomain != current_user.company.subdomain
        redirect_to root_url(:subdomain => current_user.company.subdomain)
      end
    else
      if !request.subdomain.blank?
        redirect_to root_url(:subdomain => '')
      end
    end
  end
end
