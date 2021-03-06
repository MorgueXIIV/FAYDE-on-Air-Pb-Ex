class SearchController < ApplicationController
	def result
		@pageTitle = "Search"
		query=params[:query]
		actorLimit=params[:actor]

		if (not actorLimit.blank?) then actor=Actor.find_by_name_part(actorLimit) end

		@searchMessages=[]

		if query.blank? then
			@results=[]
			@searchMessages=[]
		else
			maxSearchResults=500
			if query.index('"').nil? then
				query=query.split(" ")
			else
				query=query.split('"')
			end

			commonWords = ["the", "you", "to", "a", "i", "of", "it", "and", "in", "is", 
				"he", "this", "that", "your", "for", "on", "not", "what", "his", "it's"]
			query=query.reject{ |e| (e.length<2 or (commonWords.index(e.strip) != nil)) }

			if query.empty? then
				searchResults = []
				@searchMessages.push """Sorry, all the words from your query were filtered out. 
					Please use less common words, and ones which are longer than 1 letter"""
				@searchMessages.push """(partial and mid-word matches count, you see, so searching 'd' 
					would return everything with a 'd' in it, and that's like 53,000 records, 
					you won't want to read all that!)"""
			else
				query=query.first(10)

				querystringdisplay = query.join(", ")
				# query=query.map{|e| e.strip }
				if actor.blank? then
					searchResults = Dialogue.includes(:actor).searchTexts(query).first(maxSearchResults)
					@searchMessages.push actorLimit.blank? ? "" : "Sorry, unable to find actor with '#{actorLimit}' in their name. \n"
				else
					searchResults = Dialogue.includes(:actor).searchTextsAct(query, actor).first(maxSearchResults)
					@searchMessages.push "Searching '#{actor.name}' dialogues only. \n"
				end
				# NOTE: by this point "query" is destroyed, because the scope of Ruby passes by reference!


				if searchResults.length==maxSearchResults
					@searchMessages.push "Your search for '#{ querystringdisplay }' reached the cap of #{maxSearchResults} records. \n Perhaps a more specific search is in order?"
				else
					@searchMessages.push "Your search for  '#{ querystringdisplay }' returned #{searchResults.length} dialogue options."
				end
			end

			@results=searchResults
		end
	end
end
