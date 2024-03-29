class Check < ApplicationRecord
  belongs_to :dialogue, counter_cache: true

	def getDifficulty(difficultypassed)
    return (difficultypassed>7 ? ((difficultypassed-7)*2)-1 : difficultypassed*2) +6
  end

  def showShort
		diff=getDifficulty(difficulty.to_i)
  	return "a #{isred=="1" ? "red" : "white"} check of #{skilltype} at difficulty: #{diff} "
  end
end
