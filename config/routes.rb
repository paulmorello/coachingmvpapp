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

  # main admin page to show all games and practice sessions for review
  get '/admin', to: 'users#admin'
  get '/admin/game-reviews', to: 'users#game_reviews'
  get '/admin/practice-reviews', to: 'users#practice_reviews'

  # Update payment information and cancel account routes
  get '/users/:username/update-payment', to: 'users#update_payment'
  get '/users/:username/cancel-account', to: 'users#cancel_account'
  get '/confirmation/delete-account', to: 'users#delete_account'
  get '/confirmation/payment-confirmed', to: 'users#confirm_payment'

  # practice sessions main page will join player tendencies
  get '/tendencies', to: 'practice_sessions#tendencies'
  get '/tendencies/new', to: 'practice_sessions#new'
  get '/practice/confirmation', to: 'practice_sessions#confirmation'

  # game confirmation page
  get '/game/confirmation', to: 'games#confirmation'

end
