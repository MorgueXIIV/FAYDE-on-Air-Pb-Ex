class ConversationController < ApplicationController

	def trace
		@pageTitle = "Conversation"
		if params[:dialogueid].blank? then
		else
			idsList=params[:dialogueid].split("-")

			begin
				@conversationDescribe = Conversation.find_by_id(((idsList.first).to_i) / 10000)
				# convodias=@conversationDescribe.dialogues.includes(:actor).all
				@builtConvo = Dialogue.includes(:actor, :alternates).find(idsList)
				if not @builtConvo.index(nil).nil? then
					render :controller => 'conversation', :action => "error"
				end

				@backOptions = @builtConvo.first.origin.includes(:actor, :origin, :destination).all
				while @backOptions.length == 1 do
					@builtConvo.unshift @backOptions.first
					@backOptions=@builtConvo.first.origin.includes(:actor, :origin, :destination).all
				end

				@forwOptions = @builtConvo.last.destination.includes(:actor, :origin, :destination).all
				while @forwOptions.length == 1 do
					@builtConvo.push @forwOptions.first
					@forwOptions=@builtConvo.last.destination.includes(:actor, :origin, :destination).all
				end
				# @backOptions=[] if @backOptions.nil?

				@idsList= @builtConvo.map { |e| e.id }.join("-")

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
