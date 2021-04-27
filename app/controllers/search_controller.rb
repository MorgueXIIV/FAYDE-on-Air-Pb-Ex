class SearchController < ApplicationController
	def result
		@pageTitle = "Search"
		query=params[:query]
		if query.blank? then
			@results=[]
			@searchMessage=""
		else
			maxSearchResults=500
			query=query.split(" ")
			commonWords = ["the", "you", "to", "a", "i", "of", "it", "and", "in", "is", "he", "this", "that", "your", "for", "on", "not", "what", "his", "it's"]
			query=query.reject{ |e| (e.length<2 or (commonWords.index(e) != nil)) }
			if query.empty? then
				searchResults = []
				@searchMessage="Sorry, all the words from your query were filtered out. Please use less common words, and ones which are longer than 1 letter (partial and mid-word matches count, you see, so searchign 'd' would return everything with a 'd' in it, and that's like 53,000 records, you won't want to read all that!)"
			else
				query=query.first(10)
				searchResults = Dialogue.includes(:actor).searchTexter(query).first(maxSearchResults)

				if searchResults.length==maxSearchResults
					@searchMessage="Your search for '#{ query.join(", ") }' reached the cap of 500 records. \n Perhaps a more specific search is in order?"
				else
					@searchMessage="Your search for  '#{ query.join(", ") }' returned #{searchResults.length} dialogue options."
				end
			end

			@results=searchResults
		end
	end
end
