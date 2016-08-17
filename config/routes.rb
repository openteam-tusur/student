require 'sidekiq/web'

Rails.application.routes.draw do

  mount Sidekiq::Web => '/sidekiq'

  root to: 'application#index'

  get '/(*path)', to: 'application#index'

end
