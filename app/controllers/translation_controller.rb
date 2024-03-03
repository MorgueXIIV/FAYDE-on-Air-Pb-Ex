class TranslationController < ApplicationController
  def compare

		if params[:dialogueid].blank? then
			render :controller => 'conversation', :action => "error"
		else
			searchID=params[:dialogueid]
			@result=Dialogue.includes(:dialogueTranslations, {:actor => :actorTranslations}).find_by(id: searchID)
			# dialogue=result.id
			@actor=@result.actor #.preload(:actor_translations)
			@transla = @result.dialogueTranslations
			# @transla=@result.dialogueTranslations.joins(:actor[:actorTranslations])
			#left join actor_translations on actor.id=actor_translations.actor_id and dialogue_translations.language=actor_translations.language") #:actor_translations, :language)
			@actorsNameT = ActorTranslation.where(actor_id: @result.actor_id).pluck(:language, :string)
 			@results=[]

				@transla.each do | deet |
					@results.push( [ deet.language, (@actorsNameT.select{|name| name.first==deet.language}[0][1]), deet.string ])
				end
		end
  end
end
