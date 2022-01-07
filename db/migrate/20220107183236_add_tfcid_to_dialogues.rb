class AddTfcidToDialogues < ActiveRecord::Migration[6.1]
  def change
    # remove_column :dialogues, :tfcid, :integer
		add_column :dialogues, :tfc_id, :integer
  end
end
