class SearchController < ApplicationController
	def result
		@pageTitle = "Search"
		query=params[:query]
		actorLimit=params[:actor1]
		queryType=params[:VariableSearch]

		#Ed: This next block sets the default states of forms when results.html.erb updates
		# Morgue: It made me sad to see a 5 line if then else end, so I made it a trinary op.
		@isSearchVariable = queryType=="1" ? true : false

		@queryText = query #enables persistent search query

		#try to match the textBox entry with an Actor object
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

# change to work like::
# Order.joins(:customer, :books).pluck("orders.created_at, customers.email, books.title")

		@pageNum=params[:page].to_i
		@pageNum = 0 if  @pageNum.blank?
		@actorText = actorLimit #enables persistent actor name
		@searchMessages=[]

		if query.blank? then
			@results=[]
			@searchMessages=[]
		else
			maxSearchResults=50
			if query.index('"').nil? then
				query=query.split(" ")
			else
				query=query.split('"')
			end
			# we stopped filtering out things for doing BIG searches cos of pagination.
			# commonWords = ["the", "you", "to", "a", "i", "of", "it", "and", "in", "is",
			# 	"he", "this", "that", "your", "for", "on", "not", "what", "his", "it's"]
			# query=query.reject{ |e| (e.length<2 or (commonWords.index(e.strip) != nil)) }

			if query.empty? then
				searchResults = []
				@searchMessages.push """Sorry, all the words from your query were filtered out.
					Please use less common words, and ones which are longer than 1 letter"""
				@searchMessages.push """(partial and mid-word matches count, you see, so searching 'd'
					would return everything with a 'd' in it, and that's like 53,000 records,
					you won't want to read all that!)"""
			else
				# query=query.first(10)

				querystringdisplay = query.join(", ")
				# query=query.map{|e| e.strip }
				if queryType=="1"
					searchResults = Dialogue.includes(:actor).searchVars(query).first(maxSearchResults)
						@searchMessages.push "Searching the variables Checked / Updated for '#{querystringdisplay}'"

				else
					if actor.blank? and not actorLimit.blank? then
						@searchMessages.push "Sorry, unable to find actor with '#{actorLimit}' in their name. \n"
					end
					spareQuery = query.reverse()
					searchResults = Dialogue.includes(:actor).searchTextsAct(query, actor).offset( @pageNum*maxSearchResults).first(maxSearchResults)
					# @resultCount= Dialogue.includes(:actor).searchTexts(spareQuery).count

					if actor.blank? then
					else
						@searchMessages.push "Searching '#{actor.name}' dialogues only. \n"
					end
				end
				# NOTE: by this point "query" is destroyed, because the scope of Ruby passes by reference!

				countResults = searchResults.length
				@showPageNext = countResults >= maxSearchResults
				if @pageNum > 0 or countResults == maxSearchResults then
					@searchMessages.push "Page #{@pageNum + 1} of ??"
					if countResults == 0
						@searchMessages.push "This page left intentionally blank."
						@searchMessages.push "(Sorry, if your search has exact multiples of 50 records in it, it's not a good performance trade off to see how many results there are in advance, this blank page just gets generated to find out when there will be another 50.)"
					end
				end

				if @showPageNext then
					@searchMessages.push "Your search for '#{ querystringdisplay }' gave many results and will be shown as pages of #{maxSearchResults}. \n Perhaps a more specific search is in order?"

				else
					@searchMessages.push "Your search for  '#{ querystringdisplay }' returned #{countResults} dialogue options."
				end
			end

			@results=searchResults
			@thisPageResultStart = (@pageNum*maxSearchResults) + 1
			# @searchMessages.push "#{actor}"
		end
	end

	def conversation_index
		@pageTitle="Conversations"

		query=params[:query]

		actorLimit=params[:actor]

	end
end
