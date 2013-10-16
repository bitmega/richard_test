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

    #Redirect to subdomain only if user signed in and is on different subdomain
    if user_signed_in? && current_user.company.subdomain != request.subdomain
      redirect_to root_url(:subdomain => current_user.company.subdomain)
    elsif !user_signed_in? && !request.subdomain.blank?
      redirect_to root_url(:subdomain => '')
    end
  end
end
