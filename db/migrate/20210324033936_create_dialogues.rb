class CreateDialogues < ActiveRecord::Migration
  def change
    create_table :dialogues do |t|
      # t.primary_key :id
      t.references :conversation, index: true, foreign_key: true
      t.integer :incid
      t.references :actor
      t.string :title
      t.integer :difficultypass
      t.text :sequence
      t.text :conditionstring
      t.text :userscript

      t.timestamps null: false
    end
    create_table :dialogue_links do |t|
      t.integer :origin_id
      t.integer :destination_id
      t.integer :priority
    end
  end
end

