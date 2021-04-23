class ConversationController < ApplicationController

	def trace
		if params[:dialogueid].blank? then
		else
			idsList=params[:dialogueid].split("-")

			@builtConvo = idsList.map { |e| Dialogue.find(e) }

			@backOptions = @builtConvo.first.origin.all
			while @backOptions.length == 1 do
				@builtConvo.unshift @backOptions.first
				@backOptions=@builtConvo.first.origin.all		
			end
			@forwOptions = @builtconvo.last.destination.all
			while @forwOptions.length == 1 do
				@builtConvo.push @forwOptions.first
				@forwOptions=@builtConvo.last.destination.all		
			end
		end
	end
end
