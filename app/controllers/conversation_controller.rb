class ConversationController < ApplicationController

	def trace
		if params[:dialogueid].blank? then
		else
			thisDialogue = Dialogue.find(params[:dialogueid])

			@builtConvo = []
			@builtConvo.push(thisDialogue)

			@backOptions = thisDialogue.origin.all
			while @backOptions.length == 1 do
				@builtConvo.unshift @backOptions.first
				@backOptions=@builtConvo.first.origin.all		
			end
			@forwOptions = thisDialogue.destination.all
			while @forwOptions.length == 1 do
				@builtConvo.push @forwOptions.first
				@forwOptions=@builtConvo.last.destination.all		
			end
		end
	end
end
