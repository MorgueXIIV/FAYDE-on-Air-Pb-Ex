class CreateActorTranslations < ActiveRecord::Migration[6.1]
	def change
    create_table :actor_translations do |t|
      t.integer :actor_id
      t.string :language
      t.string :string

    end
    add_index :actor_translations, :id
    end
  end
