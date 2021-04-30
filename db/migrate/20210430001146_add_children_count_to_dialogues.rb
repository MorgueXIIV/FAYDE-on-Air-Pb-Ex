class AddChildrenCountToDialogues < ActiveRecord::Migration[5.2]
  def change
    add_column :dialogues, :origins_count, :integer
    add_column :dialogues, :destinations_count, :integer
    add_column :dialogues, :alternates_count, :integer
    add_column :dialogues, :checks_count, :integer
  end
end
