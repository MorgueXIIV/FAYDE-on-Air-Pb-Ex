class Check < ApplicationRecord
  belongs_to :dialogue, counter_cache: true

  def showShort
  	return "a #{isred ? "red" : "white"} #{difficulty} check of #{skilltype}"
  end
end
