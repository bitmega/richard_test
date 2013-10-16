FactoryGirl.define do
  factory :company do
    name { Faker::Company.name }
    subdomain { Faker::Internet.domain_word }
  end
end