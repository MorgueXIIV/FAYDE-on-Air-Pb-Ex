class TranslationController < ApplicationController
  def compare

		if params[:dialogueid].blank? then
			render :controller => 'conversation', :action => "error"
		else
			searchID=params[:dialogueid]
			@result=Dialogue.includes(:actor,:dialogueTranslations).find_by(id: searchID)
			@actorsNameT = ActorTranslation.where(actor_id: @result.actor_id)
		end
  end
end
