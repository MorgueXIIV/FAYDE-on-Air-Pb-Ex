class CreateDialogueTranslations < ActiveRecord::Migration[6.1]
  def change
    create_table :dialogue_translations do |t|
      t.integer :dialogue_id
      t.string :language
      t.string :string

    end
    add_index :dialogue_translations, :id
  end
end
