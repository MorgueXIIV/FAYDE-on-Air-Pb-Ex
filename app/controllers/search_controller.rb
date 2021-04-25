class SearchController < ApplicationController
	def result
		@pageTitle = "Search"
		query=params[:query]
		if query.blank? then
			@results=[]
		else
			# searchResults = Dialogue.where("dialoguetext LIKE ?", "%#{params[:query]}%").first(500)
			query=query.split(" ")
			if query.length == 1 then
				searchResults = Dialogue.searchText(query.first)
			else
				searchResults = Dialogue.searchText(query.first).searchText(query.last)
			end

			@results=searchResults
			# @resultStrings = searchResults.map { |result| result.showShort }
		end
	end
end
