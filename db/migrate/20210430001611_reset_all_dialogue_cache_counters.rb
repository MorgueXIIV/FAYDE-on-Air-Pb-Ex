class ResetAllDialogueCacheCounters < ActiveRecord::Migration[5.2]
  def change
 	Dialogue.all.each do |dialogue|
     Dialogue.reset_counters(dialogue.id, :alternates, :checks, :parents, :children)
   # Dialogue.reset_counters(dialogue.id, :destinations)
   # end
   # Alternates.all.each do |alt| :origins_count, :destinations_count, 
   
   # Dialogue.reset_counters(dialogue.id, :alternates)
     
   # end 
   # Checks.all.each do |check|
    
   # Dialogue.reset_counters(dialogue.id, :checks)
     
    end

  end

end