Rails.application.routes.draw do
  resources :favourites
  devise_for :users
  resources :stories
  resources :likes, only: [:create, :destroy]
  resources :dislikes, only: [:create, :destroy]
  get 'my_stories', to: 'stories#my_stories'
  get 'play', to: 'stories#play_story'
  get 'play/:id', to: 'stories#play'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "stories#index"
end
