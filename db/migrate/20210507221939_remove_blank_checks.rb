class RemoveBlankChecks < ActiveRecord::Migration[5.2]
  def change
  	blanks= Check.where("length(flagname)<3")
  	blanks.each do |bla|
  		bla.destroy
  	end
  end
    # Dialogue.all.each do |dialogue|
    #    Dialogue.reset_counters(dialogue.id, :checks)     
    # end
end
