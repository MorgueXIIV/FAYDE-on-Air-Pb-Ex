class CreateDialogues < ActiveRecord::Migration
  def change
    create_table :dialogues do |t|
      t.references :conversation, index: true, foreign_key: true
      t.int :incid
      t.references :actor
      t.string :title
      t.int :difficultypass
      t.text :sequence
      t.text :conditionstring
      t.text :userscript

      t.timestamps null: false
    end
    create_table :dialogue_links
      t.int :origin_id
      t.int :destination_id
      t.int :priority
  end
end

