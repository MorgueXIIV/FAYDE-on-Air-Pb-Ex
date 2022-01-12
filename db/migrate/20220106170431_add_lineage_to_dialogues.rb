class AddLineageToDialogues < ActiveRecord::Migration[6.1]
  def change
    add_column :dialogues, :lineage, :integer
  end
end
