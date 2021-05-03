class FaydeController < ApplicationController
  def index
  end

  def css_configuration
  	@formMessage=""
  	if params[:css]== "darkmode"
  		cookies[:sammode]=true
  		cookies[:sybmode]=false
  		@formMessage+= " Dark Mode enabled."
  	elsif params[:css]=="nocss"
  		cookies[:sybmode]=true
  		cookies[:sammode]=false
  		@formMessage+=" Minimal css mode enabled."
  	end
  	if params[:linespace]=="1" 
  		cookies[:nicmode]=true
  		@formMessage += " Linespace set to 1.5x."
  	else
  		cookies[:nicmode]=false
  		@formMessage += " Linespace set to 1x"
  	end

  end
end
