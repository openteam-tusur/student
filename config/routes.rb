Rails.application.routes.draw do

  root to: 'application#index'

  get '/(*path)', to: 'application#index'

end
