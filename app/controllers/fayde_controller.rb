class FaydeController < ApplicationController
  def index
  	@pageTitle="Home"
  end

  def css_configuration
  	@pageTitle="Configuration"
  	@formMessage=""

  	if params[:css]== "darkmode"
  		cookies[:css]="sammode"
  	elsif params[:css]=="nocss"
  		cookies[:css]="sybmode"
  	end

  	if params[:linespace]=="oneandhalf" 
  		cookies[:nicmode]=true
  	elsif params[:linespace]=="one"
  		cookies[:nicmode]=false
  	end

  	if cookies[:css]=="sammode"
  		@formMessage+= " Dark Mode enabled."
  	elsif cookies[:css]=="sybmode"
  		@formMessage+=" Minimal css mode enabled."
  	end

  	if cookies[:nicmode]
  		@formMessage += " Linespace set to 1.5x."
  	else
  		@formMessage += " Linespace set to 1x"
  	end

  	# if params[:clear]==true
  	# 	cookies.each_key do |key|
  	# 		cookies.delete key
  	# 	end
  	# end

  end
end
