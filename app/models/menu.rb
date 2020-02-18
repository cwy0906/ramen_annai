class Menu < ApplicationRecord
  belongs_to :store
  default_scope { order(:position) }
end
