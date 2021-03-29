class CreateActors < ActiveRecord::Migration[5.2]
  def change
    create_table :actors, id: false do |t|
      t.primary_key :id
      t.string :name
      t.text :description

      t.timestamps null: false
    end
  end
end
