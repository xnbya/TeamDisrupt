Rails.application.routes.draw do
  # devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "home#index"

  get '/home' => 'home#home'

  get '/references' => 'reference#index'
  get '/references/create' => 'reference#new'
  post '/references/create' => 'reference#create'
  get '/references/:id' => 'reference#show', as: :reference

  devise_for :users, :controllers => {
    :registrations => "users/registrations"
  }
end
