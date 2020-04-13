Rails.application.routes.draw do

  root to: redirect('index.html')

  # Client role routes
  #
  # html and json versions
  get 'status', to: 'users#status'

  get 'known_merchants', to:  'users#known_merchants'
  get 'transfer_code', to: 'users#transfer_code'
  put 'enqueue', to: 'users#enqueue'
  put 'dequeue', to: 'users#dequeue'
  post 'add_merchant', to: 'users#add_merchant'
  post 'transfer', to: 'users#transfer'



  # deprecated.
  post 'enable_queue', to: 'users#enable_queue'
  post 'disable_queue', to: 'users#disable_queue'


  # Management role routes
  #
  
  # html and json versions
  get 'management_status', to: 'merchants#manage_status'
  get 'join_code', to: 'merchants#join_code'
  get 'management_settings', to: 'merchants#show'
  put 'management_settings', to: 'merchants#update'
  post 'empty_queue', to: 'merchants#empty_queue'



end
