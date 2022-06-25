class ConversationController < ApplicationController

	def trace
		@pageTitle = "Conversation"
		if params[:dialogueid].blank? then
			render :controller => 'conversation', :action => "error"
		else
				convosLinksReq= DialogueLink
				idsList=params[:dialogueid].split("-").map{ |e| e.to_i }
				@conversationDescribe = []
				convoIDs= (((idsList.map{ |e| e / 10000 }).uniq))
				convosLinks=[]

				findLinks = Proc.new { |id|
									min=id*10000
									max=(id+1)*10000
									convosLinksReq = (DialogueLink.where("origin_id between ? and ? or destination_id between ? and ?", min, max, min, max))
									convosLinks += convosLinksReq.pluck(:origin_id, :destination_id)
								}

				@conversationDescribe=( Conversation.where(id: convoIDs) )
				convoIDs.each { | convoID | convosLinks += findLinks.call convoID }

			begin

				# 	# this breaks where two conversations link together so I gotta do this nasty thing to get those other links
				# 	# make a list of convos we've retrieved
				# convosWhoseLinksWeHave = convoIDs
				# 	# flatten array of arrays so it's a list of endpoints and startpoints alike, then divide each by ten thougsand to make it a conversation id, then get only the unique ones, then select the ones that are not already in the links-we-have list.
				# extraConvosNeeded = ((convosLinks.flatten.map{ |e| (e / 10000) }.uniq) - convosWhoseLinksWeHave)
				# while not extraConvosNeeded.blank? do
				# 	extraConvosLinks = []
				# 	extraConvosNeeded.each do | xlink |
				# 		min=xlink*10000description
				# 		max=(xlink+1)*10000
				# 		extraConvosLinks = extraConvosLinks + DialogueLink.where(origin_id: min..max).or(DialogueLink.where(destination_id: min..max)).pluck(:origin_id, :destination_id)
				# 	end
				# 	convosLinks = convosLinks+extraConvosLinks
				# 	convosWhoseLinksWeHave = convosWhoseLinksWeHave + extraConvosNeeded
				# 	# re-run this horrible method chain to check if there are more now
				# 	extraConvosNeeded = ((extraConvosLinks.flatten.map{ |e| (e / 10000) }.uniq) - convosWhoseLinksWeHave)
				# end

				backOptions = convosLinks.select { |l| (l[1].to_i == idsList[0]) }.map{ |e| e[0].to_i }
				while backOptions.length == 1 do
					idsList.unshift backOptions[0]
					backOptions = convosLinks.select{ |l| (l[1].to_i==idsList[0]) }.map { |e| e[0].to_i }
					checkForOutliers = (backOptions.map{ |e| e / 10000 }.uniq) - convoIDs
					if not checkForOutliers.blank? then
						convoIDs += checkForOutliers
						checkForOutliers.each{ |e| findLinks.call e }
					end
				end

				forwOptions = convosLinks.select { |l| (l[0].to_i==idsList.last) }.map { |e| e[1].to_i }
				while forwOptions.length == 1 do
					idsList.push forwOptions[0]
					forwOptions = convosLinks.select { |l| (l[0].to_i==idsList.last) }.map { |e| e[1].to_i }
					checkForOutliers = (forwOptions.map{ |e| e / 10000 }.uniq) - convoIDs
					if not checkForOutliers.blank? then
						convoIDs += checkForOutliers
						checkForOutliers.each{ |e| findLinks.call e }
					end
				end

				idsRetrieving = (idsList+forwOptions)
				dialoguesUsing = Dialogue.includes(:actor, :alternates, :checks).where(id: idsRetrieving)
				dialoguesUsing = dialoguesUsing + Dialogue.includes(:actor, :alternates, :checks, :origin).where(id: backOptions)

				@builtConvo = idsList.map { |e| dialoguesUsing.find{|f| f.id==e }}
				#
				# @forwOptions = forwOptions.map { |e| dialoguesUsing.find{|f| f.id==e}}
				# @backOptions = backOptions.map { |e| dialoguesUsing.find{|f| f.id==e}} #Dialogue.includes(:actor, :alternates).find_by_id(backOptions)
				@forwOptions = @builtConvo.last.destination.includes(:actor).all
				@backOptions = @builtConvo.first.origin.includes(:actor, :origin).all

				@idsList= idsList.join("-")
			rescue ActiveRecord::RecordNotFound
			end
		end
	end

	def error
		@pageTitle = "Error"
	end

	def oldredirect
		if params[:dialogueid].blank? then
		else
			@pageTitle="Redirecting..."

			idsList=params[:dialogueid].split("-")

			idsList.map! { |e| (TfcTransform.find_by_id(e))}
			idsList.reject! { |e| e.nil? }
			if idsList.length>0 then
				idsList.map! { |e| (e.dialogue_id)}
				redirect_to :controller => 'conversation', :action => "trace", :dialogueid => idsList.join("-")
			else
				redirect_to :controller => 'conversation', :action => "trace", :dialogueid => params[:dialogueid]
			end
		end
	end

	def orbindex
		@pageTitle="ORB MODE"
		@allorbs=Conversation.where("title LIKE ?", "%orb%").pluck(:dialogues_count,:title,:id,:description) #.order(:dialogues_count, :desc)
	end
end
