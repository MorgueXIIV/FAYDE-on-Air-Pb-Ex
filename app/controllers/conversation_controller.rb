class ConversationController < ApplicationController

	def trace
		@pageTitle = "Conversation"
		if params[:dialogueid].blank? then
		else
			idsList=params[:dialogueid].split("-")

			@builtConvo = idsList.map { |e| Dialogue.find(e) }

			firstc = @builtConvo.first
			@conversationDescribe = firstc.conversation

			@backOptions = firstc.origin.all
			while @backOptions.length == 1 do
				@builtConvo.unshift @backOptions.first
				@backOptions=@builtConvo.first.origin.all		
			end

			@forwOptions = @builtConvo.last.destination.all
			while @forwOptions.length == 1 do
				@builtConvo.push @forwOptions.first
				@forwOptions=@builtConvo.last.destination.all		
			end

			@idsList= @builtConvo.map { |e| e.id }.join("-")
		end
	end
end
