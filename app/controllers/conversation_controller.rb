class ConversationController < ApplicationController

	def trace
		@pageTitle = "Conversation"
		if params[:dialogueid].blank? then
		else
			idsList=params[:dialogueid].split("-")

			begin
				@builtConvo = idsList.map { |e| Dialogue.includes(:actor).find(e) }

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
				render :controller => 'conversation', :action => "error"
			end
		end
	end
	def error
	end
end
