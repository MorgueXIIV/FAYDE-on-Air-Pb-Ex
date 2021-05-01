class ResetAllDialogueCacheCounters < ActiveRecord::Migration[5.2]
  def change
   	Dialogue.all.each do |dialogue|
       Dialogue.reset_counters(dialogue.id, :alternates, :checks, :parents, :children)     
    end
  end
end