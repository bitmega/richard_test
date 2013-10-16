require 'spec_helper'

describe UsersController do
  before do
    @company = Company.new
    @company.name = 'test company'
    @company.subdomain = 'test'

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
    end
    it "returns list of users" do
      get 'index'
      assigns(:users).should_not be_nil
    end
  end

end
