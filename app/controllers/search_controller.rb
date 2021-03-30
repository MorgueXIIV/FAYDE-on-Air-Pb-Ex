class SearchController < ApplicationController
	def result
		if params[:query].blank? then
			@resultStrings=[]
		else
			searchResults = Dialogue.where("dialoguetext LIKE ?", "%#{params[:query]}%")
			@resultStrings = searchResults.map { |result| result.showShort }
		end
	end
end
