class UsersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :load_account

  #GET /users
  def index
    @page = params[:page] || 1
    @per_page = params[:per_page] || 20
    @users = @company.users.where("id NOT IN(?)", current_user.id)
      .paginate(page: @page, per_page: @per_page)
  end

  #GET /users/new
  def new
    @user = @company.users.new
  end

  #POST /users
  def create
    @user = @company.users.new(user_params)
    if @user.save
      redirect_to users_path
    else
      flash[:alert] = @user.errors.full_messages
      render "new"
    end
  end

  #GET /users/:id/edit
  def edit
    @user = User.find(params[:id])
    authorize! :update, @user
  end

  #PUT /users/:id
  def update
    @user = User.find(params[:id])
    authorize! :update, @user
    if @user.update_attributes(user_params)
      flash[:notice] = t(".update_success")
      redirect_to users_path
    else
      render "edit"
    end
  end

  #DELETE /users/:id
  def destroy
    @user = User.find(params[:id])

    authorize! :delete, @user
    if @user.destroy
      flash[:notice] = t(".destroy_success")
    else
      flash[:alert] = t(".destroy_failure")
    end
    redirect_to users_path
  end
private
  def load_account
    #make sure that only admin can manage users
    authorize! :manage, User
    @company = current_user.company
  end

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end
end
