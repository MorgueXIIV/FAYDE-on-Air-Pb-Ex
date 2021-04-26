class CreateChecks < ActiveRecord::Migration[5.2]
  def change
    create_table :checks do |t|
      t.string :isred
      t.string :difficulty
      t.string :flagname
      t.string :skilltype
      t.references :dialogue, foreign_key: true
    end
  end
end
