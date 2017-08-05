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
  get '/dashboard/:username', to: 'users#dashboard'

  # main admin page to show all games and practice sessions for review
  get '/admin', to: 'users#admin'
  get '/admin/game-reviews', to: 'users#game_reviews'
  get '/admin/practice-reviews', to: 'users#practice_reviews'

  # Update payment information and cancel account routes
  get '/users/:username/update-payment', to: 'users#update_payment'
  get '/users/:username/cancel-account', to: 'users#cancel_account'
  get '/confirmation/delete-account', to: 'users#delete_account'
  get '/confirmation/payment-confirmed', to: 'users#confirm_payment'
  patch '/admin/admin-access', to: 'users#admin_access'

  # practice sessions main page will join player tendencies
  get '/tendencies/:username', to: 'practice_sessions#tendencies'
  get '/tendencies/member/:username/:id', to: 'practice_sessions#practice_view'
  get '/tendencies/new', to: 'practice_sessions#new'
  get '/practice/confirmation', to: 'practice_sessions#confirmation'
  get '/admin/practice/:id/show', to: 'practice_sessions#show'
  get '/admin/practice/:id/show/admin-review', to: 'practice_sessions#admin_review'
  patch '/complete-practice-review', to: 'practice_sessions#complete_review'
  get '/admin/complete-practice-review/confirmed', to: 'practice_sessions#confirm_complete_review'

  # game confirmation page, show pages and member review pages
  get '/games/member/:username', to: 'games#index'
  get '/games/member/:username/:id', to: 'games#game_view'
  get '/game/confirmation', to: 'games#confirmation'
  get '/admin/game/:id/show', to: 'games#show'
  get '/admin/game/:id/show/admin-review', to: 'games#admin_review'
  get '/admin/complete-game-review/confirmed', to: 'games#confirm_complete_review'

  # user stat show page
  get '/stats/member/:username', to: 'stats#index'

end
