class SearchController < ApplicationController
	def result
		@pageTitle = "Search"
		query=params[:query]
		actor=Actor.find_by_name_part(params[:actor])
		if query.blank? then
			@results=[]
			@searchMessage=""
		else
			maxSearchResults=500
			if query.index('"').nil? then
				query=query.split(" ")
				commonWords = ["the", "you", "to", "a", "i", "of", "it", "and", "in", "is", 
					"he", "this", "that", "your", "for", "on", "not", "what", "his", "it's"]
				query=query.reject{ |e| (e.length<2 or (commonWords.index(e) != nil)) }
			else
				query=query.split('"')
				query=query.reject{ |e| (e.length<2) }
			end
			if query.empty? then
				searchResults = []
				@searchMessage="""Sorry, all the words from your query were filtered out. 
					Please use less common words, and ones which are longer than 1 letter 
					(partial and mid-word matches count, you see, so searching 'd' 
					would return everything with a 'd' in it, and that's like 53,000 records, 
					you won't want to read all that!)"""
			else
				query=query.first(10)
				# query=query.map{|e| e.strip }
				if actor.blank? then
					searchResults = Dialogue.includes(:actor).searchTexts(query).first(maxSearchResults)
					@searchMessage = params[:actor].blank? ? "" : "Sorry, unable to find actor with '#{params[:actor]}' in their name. \n"
				else
					searchResults = Dialogue.includes(:actor).searchTextsAct(query, actor).first(maxSearchResults)
					@searchMessage = "Searching '#{actor.name}' dialogues only. \n"
				end

				if searchResults.length==maxSearchResults
					@searchMessage+="Your search for '#{ query.join(", ") }' reached the cap of 500 records. \n Perhaps a more specific search is in order?"
				else
					@searchMessage+="Your search for  '#{ query.join(", ") }' returned #{searchResults.length} dialogue options."
				end
			end

			@results=searchResults
		end
	end
end
