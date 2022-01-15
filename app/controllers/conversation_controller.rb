class ConversationController < ApplicationController

	def trace
		@pageTitle = "Conversation"
		if params[:dialogueid].blank? then
		else
			idsList=params[:dialogueid].split("-")

				convoID= ((idsList.first).to_i) / 10000
				@conversationDescribe = Conversation.find_by_id(convoID)
				# convodias=@conversationDescribe.dialogues.includes(:actor).all

				# @builtConvo = Dialogue.includes(:actor, :alternates).find(idsList)
				# if not @builtConvo.index(nil).nil? then
				# 	render :controller => 'conversation', :action => "error"
				# end
				min=convoID*10000
				max=convoID*11000

				convosLinks = DialogueLink.where(origin_id: min..max).or(DialogueLink.where(destination_id: min..max))
				convosLinks = convosLinks.pluck(:origin_id, :destination_id)
				 #.where("origin_id between or destination_id like ?", "#{convoID}%"))

				backOptions = convosLinks.select { |l| (l[1] == idsList[0].to_i) }.map { |e| e[0] }
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


				# @backOptions = @builtConvo.first.origin.includes(:actor, :origin, :destination).all
				# while @backOptions.length == 1 do
				# 	@builtConvo.unshift @backOptions.first
				# 	@backOptions=@builtConvo.first.origin.includes(:actor, :origin, :destination).all
				# end

				# @forwOptions = @builtConvo.last.destination.includes(:actor, :origin, :destination).all
				# while @forwOptions.length == 1 do
				# 	@builtConvo.push @forwOptions.first
				# 	@forwOptions=@builtConvo.last.destination.includes(:actor, :origin, :destination).all
				# end

				idsRetrieving = (idsList+forwOptions+backOptions)
				dialoguesUsing = Dialogue.includes(:actor, :alternates, :origin).where(id: idsRetrieving)

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
