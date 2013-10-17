class Company < ActiveRecord::Base
  has_many :users, :dependent => :destroy
  validates_presence_of :name
  validates_presence_of :subdomain
  validates_uniqueness_of :subdomain
  before_save :standardize_subdomain

  private
  def standardize_subdomain
    self.subdomain.downcase.strip! if self.subdomain
  end
end
