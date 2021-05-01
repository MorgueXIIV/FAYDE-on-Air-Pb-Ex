class AddDialoguesCountToActors < ActiveRecord::Migration[5.2]
  def change
    add_column :actors, :dialogues_count, :integer
 	Actor.all.each do | actor |
    	Actor.reset_counters(actor.id, :dialogues)
    end
  end
end
