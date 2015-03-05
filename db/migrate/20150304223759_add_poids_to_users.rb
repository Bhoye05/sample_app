class AddPoidsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :poids, :float
    add_column :users, :poids_ideal, :float
  end

  def self.down
    remove_column :users, :poids_ideal
    remove_column :users, :poids
  end
end
