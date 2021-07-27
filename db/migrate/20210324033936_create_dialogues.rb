class CreateDialogues < ActiveRecord::Migration[5.2]
  def change
    create_table :dialogues do |t|
      t.references :conversation, index: true, foreign_key: true
      t.text :dialoguetext
      t.integer :incid
      t.references :actor
      t.string :title
      t.integer :difficultypass
      t.text :sequence
      t.text :conditionstring
      t.text :userscript

      t.timestamps null: false
    end
  end
end

