class AddDialoguesCountToConversations < ActiveRecord::Migration[5.2]
  def change
    add_column :conversations, :dialogues_count, :integer
    Conversation.all.each do | dia |
    	Conversation.reset_counters(dia.id, :dialogues)
    end
  end
end
