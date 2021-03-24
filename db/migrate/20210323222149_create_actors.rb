class CreateActors < ActiveRecord::Migration
  def change
    create_table :actors do |t|
      t.primary_key :id
      t.string :name
      t.text :description

      t.timestamps null: false
    end
  end
end
