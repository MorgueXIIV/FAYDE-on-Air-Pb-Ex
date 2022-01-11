class CreateTfcTransforms < ActiveRecord::Migration[6.1]
	def up
		create_table :tfc_transforms do |t|
	    t.belongs_to :dialogue, null: false, foreign_key: true
		end

		Dialogue.connection.execute "insert into tfc_transforms select tfc_id as \"id\", id as \"dialogue_id\" FROM dialogues WHERE length(dialoguetext)>2 and tfc_id not null;"
		remove_column :dialogues, :tfc_id
	end

	# def down
	# 	# could actually write something to populate the table back again but would prefer not to bother, if that's an option
	# 	remove_table

  # def up
  #   create_table :tfc_transforms do |t|
  #     t.belongs_to :dialogue, null: false, foreign_key: true
  #   end
	# 	Dialogue.not.is_hub.each do |dialogue|
	# 	 TFCTransform.create(id: dialogue.tfc_id, dialogue_id: dialogue.id)
	#  	end
	#  	remove_column :dialogues, :tfc_id,
  # end
	# def down
	# 	add_column :dialogues, :tfc_id,
	# Dialogue.not.is_hub.each do |dialogue|
	# 	 TFCTransform.create(id: dialogue.tfc_id, dialogue_id: dialogue.id)
	# end
end
