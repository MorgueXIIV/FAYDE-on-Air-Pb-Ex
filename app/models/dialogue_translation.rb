class DialogueTranslation < ApplicationRecord
	belongs_to :dialogue, :foreign_key => 'dialogue_id'
	has_one :actor, through: :dialogue
end
