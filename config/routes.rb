Rails.application.routes.draw do
  root  'search#result'
	get '/info', to: 'fayde#index'

  get '/search', to: 'search#result', as: 'search'
  get '/search/:query', to: 'search#result', as: 'search_inline'
  get '/search/:query/:actor', to: 'search#result', as: 'search_inline_actor'

  get '/configure', to: 'fayde#css_configuration', as: 'configure'
  get '/configue/:css', to: 'fayde#css_configuration', as: 'configured'

  get '/dialogue/:dialogueid', to: 'conversation#trace', as: 'dialogue'
  get '/dialogue/error', to: 'conversation#error', as: 'invalid_dialogue_id'

  get '/orbmode', to: 'conversation#orbindex', as: 'orb_index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
