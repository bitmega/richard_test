class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable
  belongs_to :company
  validates_presence_of :password, if: :password_required?
  validates_confirmation_of :password_confirmation
  validates_uniqueness_of :email, scope: :company_id
  validates_presence_of :email, :username
  validates_uniqueness_of :username, scope: :company_id

  attr_accessor :subdomain

  def password_required?
    !persisted? || !password.nil? || !password_confirmation.nil?
  end

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    username = conditions[:username]
    subdomain = conditions[:subdomain]

    if username && subdomain
      self.joins(:company).where(:username => username,
        "companies.subdomain" => subdomain).readonly(false).first
    else
      nil
    end
  end
end
