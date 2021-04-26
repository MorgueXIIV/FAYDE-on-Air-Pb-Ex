class RemoveTimestampsFromActors < ActiveRecord::Migration[5.2]
  def change
    remove_column :actors, :created_at, :string
    remove_column :actors, :updated_at, :string
  end
end
