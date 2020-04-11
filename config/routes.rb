Rails.application.routes.draw do
  #resources :merchants 
  get 'known_merchants', to:  'users#known_merchants'
  post 'enqueue', to: 'users#enqueue'
  delete 'dequeue', to: 'users#dequeue'
  get 'status', to: 'users#status'
  get 'merchant', to: 'users#merchant'
  get 'transfer_code', to: 'users#transfer_code'

  #resources :queue, path: '/users/queue', only: [ :create ]
  #get '/users/:id/slots', to: 'merchants#slots'
  #post '/users/session', to: 'merchants#create'
  #post '/users/:id/enqueue', to: 'merchants#enqueue'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
