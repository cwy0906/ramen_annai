class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :store
  validates  :score, presence: true
  validates  :visit_time, presence: true
  validates  :spend, presence: true
  validates  :content, presence: true
end
