Rails.application.routes.draw do
  resources :merchants 
  get '/merchants/:id/slots', to: 'merchants#slots'
  post '/merchants/:id/enqueue', to: 'merchants#enqueue'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
