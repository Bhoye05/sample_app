class RemoveAddPaperclipsToUser < ActiveRecord::Migration
  def self.up
    remove_column :users, :attach_content_type
    remove_column :users, :attach_file_size
    remove_column :users, :attach_updated_at
  end

  def self.down
    add_column :users, :attach_content_type, :string
    add_column :users, :attach_file_size,    :integer
    add_column :users, :attach_updated_at,   :datetime
  end
end
