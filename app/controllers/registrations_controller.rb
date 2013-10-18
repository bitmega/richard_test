class RegistrationsController < Devise::RegistrationsController
  #POST /auth
  def create
    @company = Company.new(company_params)
    params[:user].delete :company

    resource = build_resource(user_params)
    resource.company = @company
    resource.admin = true
    begin
      ActiveRecord::Base.transaction do
        @company.save!
        resource.save!
      end

      sign_in resource, by_pass: true
      redirect_to root_path
    rescue
      unless @company.errors.empty?
        @company.errors.each do |attr, error|
          resource.errors.add(attr, error)
        end
      end
      respond_with(resource)
    end
  end

  #GET /company_info
  def company_info
  end

  private
  def company_params
    params[:user].require(:company).permit(:name, :subdomain)
  end

  def user_params
    params.require(:user).permit(:email, :username, :password, :password_confirmation)
  end
end