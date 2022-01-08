class ConversationController < ApplicationController

	def trace
		@pageTitle = "Conversation"
		if params[:dialogueid].blank? then
		else
			idsList=params[:dialogueid].split("-")

			begin
				@builtConvo = idsList.map { |e| Dialogue.includes(:actor).find_by_id(e) }
				if not @builtConvo.index(nil).nil? then
					render :controller => 'conversation', :action => "error"
				end

				firstc = @builtConvo.first
				@conversationDescribe = firstc.conversation

				@backOptions = firstc.origin.includes(:actor).all
				while @backOptions.length == 1 do
					@builtConvo.unshift @backOptions.first
					@backOptions=@builtConvo.first.origin.includes(:actor).all
				end

				@forwOptions = @builtConvo.last.destination.all
				while @forwOptions.length == 1 do
					@builtConvo.push @forwOptions.first
					@forwOptions=@builtConvo.last.destination.includes(:actor).all
				end

				@idsList= @builtConvo.map { |e| e.id }.join("-")
			rescue
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

			idsList.map! { |e| (Dialogue.find_by_tfc_id(e))}
			idsList.reject! { |e| e.nil? }
			if idsList.length>0 then
				idsList.map! { |e| (e.id)}
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
