Rails.application.routes.draw do
  root 'fayde#index'

  get '/search/:query', to: 'search#result'
  get '/search', to: 'search#result'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :dialogue, only: [:index, :show]
    end
  end
end
