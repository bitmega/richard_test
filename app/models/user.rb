class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable
  belongs_to :company
  validates_uniqueness_of :email, scope: :company_id
  validates_presence_of :email, :username
  validates_uniqueness_of :username
end
