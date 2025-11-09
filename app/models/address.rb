class Address < ApplicationRecord
  has_many :user_infos

  validates :street, :city, :state, :zip_code, :neighborhood, :number, presence: true
end
