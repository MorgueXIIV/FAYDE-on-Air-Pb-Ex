class Modifier < ApplicationRecord
  belongs_to :dialogue

  def showShort
  	return "#{tooltip}, #{modification} if #{variable} "
  end
end
