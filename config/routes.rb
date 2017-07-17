Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :drills, :games, :stats, :practice_sessions, :videos
  resources :users, param: :username

  # session routes
  get '/login', to: 'session#new'
  post '/session', to: 'session#create'
  delete '/logout', to: 'session#destroy'

  # landing page and dashboard routes
  get '/', to: 'users#home'
  get '/dashboard', to: 'users#dashboard'
  get '/users/:username/update-payment', to: 'users#update_payment'

  # main admin page to show all games and practice sessions for review
  get '/admin', to: 'users#admin'

  # practice sessions main page will join player tendencies
  get '/tendencies', to: 'practice_sessions#tendencies'
  get '/tendencies/new', to: 'practice_sessions#new'
  get '/practice/confirmation', to: 'practice_sessions#confirmation'

  # game confirmation page
  get '/game/confirmation', to: 'games#confirmation'

end
