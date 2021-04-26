class CreateAlternates < ActiveRecord::Migration[5.2]
  def change
    create_table :alternates do |t|
      t.string :alternateline
      t.string :conditionstring
      t.references :dialogue, foreign_key: true
    end
  end
end
