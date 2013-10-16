class SessionsController < Devise::SessionsController
  skip_before_filter :check_subdomain
  def new
    super
  end
end