Rails.application.routes.draw do
  get 'known_merchants', to:  'users#known_merchants'
  post 'enqueue', to: 'users#enqueue'
  delete 'dequeue', to: 'users#dequeue'
  get 'status', to: 'users#status'
  get 'merchant', to: 'users#merchant'
  get 'transfer_code', to: 'users#transfer_code'
  post 'enable_queue', to: 'users#enable_queue'
  post 'disable_queue', to: 'users#disable_queue'
  post 'transfer', to: 'users#transfer'

  root to: redirect('index.html')

end
