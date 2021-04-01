class Api::V1::DialogueController < ApplicationController
    def index
        @dialogue = Dialogue.all
    end
    def show
        @dialogue = Dialogue.find(params[:id])
    end
    def set_dialogue_item
        @dialogue = Dialogue.find(params[:id])
    end
end
