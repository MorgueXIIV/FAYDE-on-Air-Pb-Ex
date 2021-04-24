class SearchController < ApplicationController
	def result
		@pageTitle = "Search"
		if params[:query].blank? then
			@results=[]
		else
			searchResults = Dialogue.where("dialoguetext LIKE ?", "%#{params[:query]}%")
			@results=searchResults
			# @resultStrings = searchResults.map { |result| result.showShort }
		end
	end

	def search  
	  if params[:search].blank?  
	    redirect_to(root_path, alert: "Empty field!") and return  
	  else  
	    @parameter = params[:search].downcase  
	    @results = Dialogue.where("dialoguetext LIKE ?", "%#{params[:query]}%")  
	  end
	end

	def form
	end
end
