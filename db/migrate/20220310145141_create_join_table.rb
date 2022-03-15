class CreateJoinTable < ActiveRecord::Migration[7.0]
  def change
    create_join_table :stories, :categories
  end
end
