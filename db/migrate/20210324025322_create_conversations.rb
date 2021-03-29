class CreateConversations < ActiveRecord::Migration[5.2]
  def change
    create_table :conversations, id: false do |t|
      t.primary_key :id
      t.string :title
      t.text :description

      t.timestamps null: false
    end
  end
end
