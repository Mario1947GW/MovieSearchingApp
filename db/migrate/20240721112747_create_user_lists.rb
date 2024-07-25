# frozen_string_literal: true

class CreateUserLists < ActiveRecord::Migration[7.1]
  def change
    create_table :user_lists do |t|
      t.belongs_to :user
      t.timestamps
    end

    create_table :user_list_items do |t|
      t.belongs_to :user_list
      t.integer :item_id
    end
  end
end
