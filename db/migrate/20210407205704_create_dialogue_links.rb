class CreateDialogueLinks < ActiveRecord::Migration[5.2]
  def change
    create_table :dialogue_links do |t|
      t.integer :origin_id
      t.integer :destination_id
      t.integer :priority
    end
  end
end
