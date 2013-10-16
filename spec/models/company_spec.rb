require 'spec_helper'

describe Company do
  context "Associations" do
    it { should have_many(:users)}
  end

  context "Validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:subdomain) }
  end
end
