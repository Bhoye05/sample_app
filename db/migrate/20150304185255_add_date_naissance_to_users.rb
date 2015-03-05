class AddDateNaissanceToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :date_naissance, :string
  end

  def self.down
    remove_column :users, :date_naissance
  end
end
