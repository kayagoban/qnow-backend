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
  
  #redirects to either 'merchants#show' or'merchants#status'
  get 'management'          , to: 'merchants#manage'

  get 'management_status', to: 'merchants#status'

  get 'management_settings', to: 'merchants#show'
  put 'management_settings', to: 'merchants#update'

  get 'queue_pdf', to: 'merchants#queue_pdf'
  post 'reset_queue', to: 'merchants#reset_queue'
  post 'reset_qrcode', to: 'merchants#reset_qrcode'


end
