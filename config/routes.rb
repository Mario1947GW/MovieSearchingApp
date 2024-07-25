# frozen_string_literal: true
Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Defines the root path route ("/")
  root 'home#index'
  get 'search', to: 'search#index'
  get 'results', to: 'search#results'
  get 'genres_list', to: 'search#genres_list'
  get 'my_list', to: 'my_list#index'
  post 'add_item_to_my_list', to: 'my_list#add_item_to_my_list'
  delete 'remove_item_from_my_list', to: 'my_list#remove_item_from_my_list'
end
