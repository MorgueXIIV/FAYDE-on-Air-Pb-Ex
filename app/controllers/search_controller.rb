class SearchController < ApplicationController
	def result
		@pageTitle = "Search"
		query=params[:query]
		if query.blank? then
			@results=[]
		else
			# searchResults = Dialogue.where("dialoguetext LIKE ?", "%#{params[:query]}%").first(500)
			query=query.split(" ")
			query=query.reject{|e| e.length<3}
			if query.empty? then
				searchResults = []
			else
				query=query.first(10)
				searchResults = Dialogue.includes(:actor).searchTexter(query).first(500)
			end

			@results=searchResults
			# @resultStrings = searchResults.map { |result| result.showShort }
		end
	end
end
