require 'spec_helper'

describe User do
  context "Associations" do
    it { should belong_to(:company)}
  end

  context "Validations" do
    it { should validate_presence_of(:username) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).scoped_to(:company_id) }
    it { should validate_uniqueness_of(:username) }
  end
end
