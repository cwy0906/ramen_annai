class Store < ApplicationRecord
  belongs_to :user
  validates  :title, presence: true
  validates  :city, presence: true
  validates  :district, presence: true
  validates  :address, presence: true
  validates  :opening_hours, presence: true
  validates  :closed_day, presence: true
  validates  :budget, presence: true
  validates  :feature, presence: true
  has_many :comments
end

