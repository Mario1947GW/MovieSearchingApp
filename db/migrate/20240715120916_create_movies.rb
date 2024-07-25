# frozen_string_literal: true
class CreateMovies < ActiveRecord::Migration[7.1]
  def change
    create_table :movies do |t|
      t.string :title
      t.string :movie_type
      t.string :genre
      t.date :released
      t.string :plot
      t.string :director
      t.string :actors
      t.timestamps
    end
  end
end
