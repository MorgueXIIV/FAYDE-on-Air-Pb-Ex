class DialoguesCountUpdateOnConversations < ActiveRecord::Migration[6.1]
  def change
		connection.execute("UPDATE conversations SET dialogues_count = (SELECT count(1) FROM dialogues WHERE dialogues.conversation_id = conversations.id)")
  end
end
