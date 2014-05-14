class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :appointments, dependent: :destroy
  has_many :services, through: :appointments

  validates :email, presence: true, uniqueness: true
  validates_presence_of :name



end
