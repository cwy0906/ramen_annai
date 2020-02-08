class Menu < ApplicationRecord
  belongs_to :store
  default_scope { order(:position) }
  acts_as_list scope: :store
end
