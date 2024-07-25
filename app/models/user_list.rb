class UserList < ApplicationRecord
  belongs_to :user
  has_many :user_list_items, dependent: :destroy
end
