class Contact < ActiveRecord::Base
  has_many :addresses

  validates :name, presence: true
  validates :email, presence: true
end
