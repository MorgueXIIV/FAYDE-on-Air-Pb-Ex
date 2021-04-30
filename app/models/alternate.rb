class Alternate < ApplicationRecord
  belongs_to :dialogue, counter_cache: true
  
  def showShort
  	return "Replaced with \"#{alternateline}\" if #{conditionstring}"
  end
end
