class AddAttachmentAttachToUsers < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.attachment :attach
    end
  end

  def self.down
    drop_attached_file :users, :attach
  end
end
