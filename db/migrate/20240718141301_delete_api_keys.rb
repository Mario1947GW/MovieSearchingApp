# frozen_string_literal: true

class DeleteApiKeys < ActiveRecord::Migration[7.1]
  def change
    remove_column :users, :api_key
  end
end
