Rails.application.routes.draw do


  #root to: redirect('status')
  root to: redirect('status')
  # Client role routes
  #
  # html and json versions
  get 'status', to: 'users#status'

  get 'known_merchants', to:  'users#known_merchants'
  post 'transfer_code', to: 'users#transfer_code'

  put 'enqueue', to: 'users#enqueue'
  put 'dequeue', to: 'users#dequeue'

  post 'join_queue', to: 'users#join_queue'
  post 'exit_queue', to: 'users#exit_queue'
 
  get 'add_queue/:id', to: 'users#add_queue'
  post 'remove_queue', to: 'users#remove_queue'

  post 'transfer', to: 'users#transfer'

  # deprecated.
  post 'enable_queue', to: 'users#enable_queue'
  post 'disable_queue', to: 'users#disable_queue'

  # Management role routes
  #
  
  #redirects to either 'merchants#show' or'merchants#status'
  get 'management'          , to: 'merchants#manage'

  post 'admit_user', to: 'merchants#admit'

  get 'management_status', to: 'merchants#status'

  get 'management_settings', to: 'merchants#show'
  put 'management_settings', to: 'merchants#update'

  post 'queue_pdf', to: 'merchants#queue_pdf'
  post 'reset_queue', to: 'merchants#reset_queue'
  post 'reset_queue_pdf', to: 'merchants#reset_queue_pdf'


end
