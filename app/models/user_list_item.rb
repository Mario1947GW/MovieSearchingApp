class UserListItem < ApplicationRecord
  belongs_to :user_list
  validates :user_list_id, presence: true
  validates :item_id, uniqueness: { scope: :user_list_id, message: I18n.t('errors.messages.user_list_item_duplicate') }
end
