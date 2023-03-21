class TranslationController < ApplicationController
  def compare

		if params[:dialogueid].blank? then
			render :controller => 'conversation', :action => "error"
		else
			searchID=params[:dialogueid]
			@result=Dialogue.includes(:dialogueTranslations).find_by(id: searchID)
		end
  end
end
