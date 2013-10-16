class WelcomeController < ApplicationController
  skip_before_filter :check_subdomain
  def index
    if user_signed_in? && current_user.company.subdomain != request.subdomain
      redirect_to root_url(:subdomain => current_user.company.subdomain)
    elsif !user_signed_in? && !request.subdomain.blank?
      redirect_to root_url(:subdomain => '')
    end
  end
end