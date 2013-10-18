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

  def after_sign_in_path_for(resource_or_scope)
    if resource_or_scope.admin?
      users_url(:subdomain => resource_or_scope.company.subdomain)
    else
      root_url(:subdomain => resource_or_scope.company.subdomain)
    end
  end

  protected
  def check_subdomain
    return if Rails.env.test?
    if request.subdomain == 'www'
      redirect_to root_url(:subdomain => '')
    else
      #Redirect to subdomain only if user signed in and is on different subdomain
      if user_signed_in? && current_user.company.subdomain != request.subdomain
        redirect_to after_sign_in_path_for(current_user)
      elsif !user_signed_in? && !request.subdomain.blank?
        redirect_to new_user_session_url
      end
    end
  end
end
