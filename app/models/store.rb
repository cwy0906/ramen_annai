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
  has_many :menus, inverse_of: :store, dependent: :destroy
  accepts_nested_attributes_for :menus, reject_if: :all_blank, allow_destroy: true
  has_many_attached :store_images

end

