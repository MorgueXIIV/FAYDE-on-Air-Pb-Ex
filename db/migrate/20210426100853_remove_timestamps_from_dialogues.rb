class RemoveTimestampsFromDialogues < ActiveRecord::Migration[5.2]
  def change
    remove_column :dialogues, :created_at, :string
    remove_column :dialogues, :updated_at, :string
  end
end
