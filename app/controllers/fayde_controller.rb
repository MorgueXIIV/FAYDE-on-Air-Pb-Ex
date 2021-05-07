class FaydeController < ApplicationController
  def index
  	@pageTitle="Home"
  end

  def css_configuration
  	@pageTitle="Configuration"
  	@formMessage=""

  	if params[:css]== "darkmode"
  		cookies[:css]="sammode"
  	elsif params[:css]== "nocss"
  		cookies[:css]="sybmode"
  	elsif params[:css]== "lightmode"
  		cookies[:css]="mogmode"
  	end

  	if not params[:linespace].blank?
  		cookies[:nicmode] = params[:linespace]
  	end

  	if cookies[:css]=="sammode"
  		@formMessage+= " Dark Mode enabled."
  	elsif cookies[:css]=="mogmode"
  		@formMessage+= " Light Mode enabled."
  	elsif cookies[:css]=="sybmode"
  		@formMessage+=" Minimal css mode enabled."
  	end

  	if cookies[:nicmode]=="onepointfive"
  		@formMessage += " Linespace set to 1.5x."
  	elsif cookies[:nicmode]=="one"
  		@formMessage += " Linespace set to 1x"
  	elsif cookies[:nicmode]=="two"
  		@formMessage += " Linespace set to 1x"
  	end

  	if params[:submit]=="clear"
  		cookies.each_key do |key|
  			cookies.delete key
  		end
  	end

  end
end
