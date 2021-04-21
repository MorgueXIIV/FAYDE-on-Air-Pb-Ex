Rails.application.routes.draw do
  root 'fayde#index'

  get '/search', to: 'search#result', as: 'search'
  get '/dialogue/:dialogueid', to: 'conversation#trace', as: 'dialogue'
  get '/dialogue/:query/:dialogueid', to: 'conversation#trace'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
