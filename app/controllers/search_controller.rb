class SearchController < ApplicationController
	def result
		@pageTitle = "Search"
		query=params[:query]
		actorLimit=params[:actor1]



		#Ed: This next block sets the default state for "variable search" when results.html.erb updates
		# Morgue: It made me sad to see a 5 line if then else end, so I made it a trinary op.
		@isSearchVariable = params[:VariableSearch]=="1" ? true : false
		@isWordBoundaries = params[:WordBoundaries]=="1" ? true : false

		@queryText = query #enables persistent search query

		#Ed - try to match the textBox entry with an Actor object
		if not actorLimit.blank? then
			actor=Actor.find_by_name_part(actorLimit)
			# check if they maybe mean Harry:
			if actorLimit.upcase.include?("HAR") or actorLimit.upcase.include?("BOIS") then
				actor=Actor.find_by_name_part("you")
				@searchMessages.push "Search for '#{actorLimit}' interpreted to mean 'You' (ie the main character)"
			end
		end
	  # Ed - if textbox is left blank or doesn't match a character, fallback on the content of Listbox, then identify the actor to use
		if actor.blank? && !(params[:actor2]).blank? then
				actor=Actor.find_by_name_part(params[:actor2])
				actorLimit=params[:actor2]
		end

		@pageNum=params[:page].to_i
		@pageNum = 0 if  @pageNum.blank?
		@actorText = actorLimit #enables persistent actor name
		@searchMessages=[]

		if query.blank? and actor.blank? then
			@results=[]
			@searchMessages=[]
		else
			maxSearchResults=100
			if query.index('"').nil? then
				query=query.split(" ")
			else
				query=query.split('"')
			end
			# we stopped filtering out things for doing BIG searches cos of pagination.
			# but serachign several keywords is still hard work so if people look like
			# they're on a whole sentence, get rid of boring words.
			if query.length > 5 or @isWordBoundaries then
				commonWords = ["the", "you", "to", "of", "it", "and", "in", "is",
					"he", "this", "that", "your", "for", "on", "not", "what", "his", "it's"]
				query=query-commonWords
				query=query.reject{ |e| (e.length<2) }
			end


			if query.empty? then
				searchResults = []
				@searchMessages.push """Sorry, all the words from your query were filtered out.
					Please use less common words, and ones which are longer than 1 letter"""
				@searchMessages.push """(partial and mid-word matches count, you see, so searching 'd'
					would return everything with a 'd' in it, and that's like 53,000 records,
					you won't want to read all that!)"""
			else
				querystringdisplay = query.join(", ")

				# search for dialogue and specify how many results to get from which "page"
				searchResults = actor.blank? ? Dialogue.includes(:alternates) : Dialogue.includes(:alternates).smartSaidBy(actor)
				searchResults = searchResults.offset(@pageNum * maxSearchResults).limit(maxSearchResults)

				if @isSearchVariable then
					#variable search is a different method and gets different attributes
					searchResultIDs = searchResults.unscope(:includes).searchVars(query).ids
					@searchMessages.push "Searching the variables Checked / Updated for '#{querystringdisplay}'"
					searchResults = Dialogue.where(id: searchResultIDs).pluck(:name, :dialoguetext, :conversation_id, :id, :title, :conditionstring, :userscript)
					countResults = searchResults.length
					@showPageNext = countResults >= maxSearchResults
				else # dialoguetext search
					if actor.blank? and not actorLimit.blank? then
						@searchMessages.push "Sorry, unable to find actor with '#{actorLimit}' in their name. \n"
					end
					searchResults= searchResults.searchTexts(query.reverse).or( searchResults.searchAlts(query.reverse))
					if @isWordBoundaries then
						resultIDs = []
						querregexes = query.map { |e| Regexp.new("\\b#{e}\\b", Regexp::IGNORECASE ) }
						searchResults = searchResults.unscope(:limit, :offset)
						scanResults = searchResults.pluck(:id, :dialoguetext, :alternateline).map { |e| [e[0],"#{e[1]} #{e[2]}"] }
						scanResults.each do | result |
							passSoFar=true
							querregexes.each do | boundWord |
								if passSoFar then
									passSoFar= result[1].match?(boundWord)
								end
							end
							if passSoFar then
								resultIDs.push result[0]
								if resultIDs.length>=100 then
									break
								end
							end
							searchResults = Dialogue.includes(:alternates).where(id: resultIDs)
						end
					end
				searchResults=searchResults.pluck(:name, :dialoguetext, :conversation_id, :id, :alternateline, "alternates.conditionstring")
				countResults=searchResults.length
				@showPageNext = countResults >= maxSearchResults
				if not actor.blank? then
					@searchMessages.push "Searching '#{actor.name}' dialogues only. \n"
				end
			end

				if @pageNum > 0 or @showPageNext then
					@searchMessages.push "Page #{@pageNum + 1} of ??"
					if countResults == 0
						@searchMessages.push "This page left intentionally blank."
						@searchMessages.push "(Sorry, if your search has exact multiples of #{maxSearchResults} records in it, it's not a good performance trade off to see how many results there are in advance, this blank page just gets generated to find out when there will be another set.)"
					end
				end

				if @showPageNext then
					@searchMessages.push "Your search for '#{ querystringdisplay }' gave many results and will be shown as several pages of #{maxSearchResults}. \n Perhaps a more specific search is in order?"
				else
					@searchMessages.push "Your search for  '#{ querystringdisplay }' returned #{countResults} dialogue options."
				end
			end

			@results=searchResults
			@thisPageResultStart = (@pageNum*maxSearchResults) + 1

		end
	end

	def conversation_index
		@pageTitle="Conversations"

		query=params[:query]

		actorLimit=params[:actor]

	end
end
