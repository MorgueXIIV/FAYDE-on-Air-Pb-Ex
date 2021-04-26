class CreateModifiers < ActiveRecord::Migration[5.2]
  def change
    create_table :modifiers do |t|
      t.string :variable
      t.string :modification
      t.string :tooltip
      t.references :dialogue, foreign_key: true
    end
  end
end
