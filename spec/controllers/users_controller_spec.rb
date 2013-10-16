require 'spec_helper'

describe UsersController do
  before do
    @company = FactoryGirl.create(:company)

    @company2 = FactoryGirl.create(:company)

    @user = FactoryGirl.create(:user)
    @user.admin = true
    @user.company = @company
    @user.save

    sign_in @user
  end

  describe "GET 'index'" do
    before do
      5.times do
        FactoryGirl.create(:user, :company_id => @company.id)
      end
      3.times do
        FactoryGirl.create(:user, :company_id => @company2.id)
      end
    end
    it "returns correct list of users" do
      get 'index'
      assigns(:users).should_not be_nil
      assigns(:users).length.should == 5
    end

    it 'only allows admin to view list of users' do
      new_user = FactoryGirl.create(:user, :company_id => @company.id)
      sign_in new_user
      get 'index'
      response.should redirect_to root_path
    end
  end

  describe "PUT index" do
    before do
      @c_user = FactoryGirl.create(:user, :company_id => @company.id)
    end
    it 'updates user info' do
      new_user = FactoryGirl.create(:user, :admin => true, :company_id => @company.id)
      sign_in new_user
      put 'update', id: @c_user.id, user: {username: 'new_username'}
      @c_user.reload.username.should == 'new_username'
    end
    it 'should only company admin to edit' do
      new_user = FactoryGirl.create(:user, :admin => true, :company_id => @company2.id)
      sign_in new_user
      put 'update', id: @c_user.id, user: {username: 'new_username'}
      response.should redirect_to root_path
    end
  end
end
