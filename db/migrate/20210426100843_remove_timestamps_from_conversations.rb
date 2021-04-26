class RemoveTimestampsFromConversations < ActiveRecord::Migration[5.2]
  def change
    remove_column :conversations, :created_at, :string
    remove_column :conversations, :updated_at, :string
  end
end
