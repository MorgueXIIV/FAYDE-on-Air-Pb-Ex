class SearchController < ApplicationController
	def result
		@pageTitle = "Search"
		if params[:query].blank? then
			@results=[]
		else
			searchResults = Dialogue.where("dialoguetext LIKE ?", "%#{params[:query]}%").first(500)
			@results=searchResults
			# @resultStrings = searchResults.map { |result| result.showShort }
		end
	end
end
