class RemoveDescriptionFromActors < ActiveRecord::Migration[5.2]
  def change
    remove_column :actors, :description, :string
  end
end
