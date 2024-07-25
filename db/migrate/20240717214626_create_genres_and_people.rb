# frozen_string_literal: true

class CreateGenresAndPeople < ActiveRecord::Migration[7.1]
  def change
    create_table :genres do |t|
      t.string :for, null: false
      t.integer :genre_id, null: false
      t.string :name, null: false
      t.timestamps
    end

    create_table :people do |t|
      t.string :name, null: false
      t.string :last_name, null: false
      t.integer :person_id, null: false
      t.timestamps
    end
  end
end
