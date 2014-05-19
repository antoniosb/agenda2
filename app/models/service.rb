class Service < ActiveRecord::Base
  has_many :appointments, dependent: :nullify
  has_many :users, through: :appointments

  validates :name, 
      format: { with: /\A[a-zA-Z]+\z/, message: "only allows letters" },
      length: { in: 2..20 },
      presence: true,
      uniqueness: true

  validates :price, 
      numericality: true,
      presence: true

  validates :duration,
      presence: true,
      numericality: true
  

end