class Company < ActiveRecord::Base
  has_many :users
  validates_presence_of :name
  validates_presence_of :subdomain
  before_save :standardize_subdomain

  private
  def standardize_subdomain
    self.subdomain.downcase.strip! if self.subdomain
  end
end
