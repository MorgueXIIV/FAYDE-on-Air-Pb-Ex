class ConversationController < ApplicationController

	def trace
		@pageTitle = "Conversation"
		if params[:dialogueid].blank? then
			render :controller => 'conversation', :action => "error"
		else
			idsList=params[:dialogueid].split("-")

				convoID= (((idsList.first).to_i) / 10000)
				@conversationDescribe = Conversation.find_by_id(convoID)
				min=convoID*10000
				max=(convoID+1)*10000

				convosLinksReq = DialogueLink.where(origin_id: min..max).or(DialogueLink.where(destination_id: min..max))
				convosLinks = convosLinksReq.pluck(:origin_id, :destination_id)
				# =begin
					# this breaks where two conversations link together so I gotta do this nasty thing to get those other links
					# make a list of convos we've retrieved
				convosWhoseLinksWeHave = Array.new.push(convoID)
					# flatten array of arrays so it's a list of endpoints and startpoints alike, then divide each by ten thougsand to make it a conversation id, then get only the unique ones, then select the ones that are not already in the links-we-have list.
				extraConvosNeeded = ((convosLinks.flatten.map{ |e| (e / 10000) }.uniq) - convosWhoseLinksWeHave)

				# while not extraConvosNeeded.blank? do
					extraConvosLinks = []
					extraConvosNeeded.each do | xlink |
						min=xlink*10000
						max=(xlink+1)*10000
						extraConvosLinks = extraConvosLinks + DialogueLink.where(origin_id: min..max).or(DialogueLink.where(destination_id: min..max)).pluck(:origin_id, :destination_id)
					end
					convosLinks = convosLinks+extraConvosLinks
					convosWhoseLinksWeHave = convosWhoseLinksWeHave + extraConvosNeeded
					# re-run this horrible method chain to check if there are more now
					extraConvosNeeded = ((extraConvosLinks.flatten.map{ |e| (e / 10000) }.uniq) - convosWhoseLinksWeHave)
				# end
				# =end

				backOptions = convosLinks.select { |l| (l[1] == idsList[0].to_i) }.map{ |e| e[0] }
				@debugmsg = "#{ idsList[0] } wibble #{backOptions}"
				while backOptions.length == 1 do
					idsList.unshift backOptions[0]
					backOptions = convosLinks.select{ |l| (l[1]==idsList[0]) }.map { |e| e[0] }
				end

				forwOptions = convosLinks.select { |l| (l[0]==idsList[-1].to_i) }.map { |e| e[1] }
				while forwOptions.length == 1 do
					idsList.push forwOptions[0]
					forwOptions = convosLinks.select { |l| (l[0]==idsList[-1]) }.map { |e| e[1] }
				end

				idsRetrieving = (idsList+forwOptions)
				dialoguesUsing = Dialogue.includes(:actor, :alternates, :checks).where(id: idsRetrieving)
				dialoguesUsing = dialoguesUsing + Dialogue.includes(:actor, :alternates, :checks, :origin).where(id: backOptions)

				@builtConvo = idsList.map { |e| dialoguesUsing.find{|f| f.id==e.to_i}}

				@forwOptions = forwOptions.map { |e| dialoguesUsing.find{|f| f.id==e.to_i}} # Dialogue.includes(:actor, :alternates).find_by_id(forwOptions)
				@backOptions = backOptions.map { |e| dialoguesUsing.find{|f| f.id==e.to_i}} #Dialogue.includes(:actor, :alternates).find_by_id(backOptions)

				# @backOptions=[] if @backOptions.nil?

				@idsList= idsList.join("-") # @builtConvo.map { |e| e.id }.join("-")
			begin
			rescue
				render :controller => 'conversation', :action => "error"
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
		@allorbs=Conversation.where("title LIKE ?", "%orb%") #.order(:dialogues_count, :desc)
	end
end
