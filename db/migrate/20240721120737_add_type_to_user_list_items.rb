# frozen_string_literal: true

class AddTypeToUserListItems < ActiveRecord::Migration[7.1]
  def change
    add_column :user_list_items, :item_type, :string
  end
end
