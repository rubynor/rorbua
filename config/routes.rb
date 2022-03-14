Rails.application.routes.draw do
  resources :favourites
  devise_for :users
  resources :stories
  resources :likes, only: [:create, :destroy]
  resources :dislikes, only: [:create, :destroy]
  resources :playlists, only: [:create, :destroy, :index, :new, :show] do
    member do
      post :new
    end
  end
  post "cancel_playlist_form", to:"playlists#cancel", as: 'cancel_playlist_form'
  resources :playlist_stories, only: [:create, :destroy]
  get 'my_stories', to: 'playlists#my_stories', as: "my_stories"
  get 'my_favourites', to: 'playlists#my_favourites', as: "my_favourites"
  get 'play/:id', to: 'stories#play', as: 'play'
  get 'playlist/play/:id', to: 'playlists#play', as: 'playlist_play'
  get 'playlist/:playlist_id/:id', to: 'playlist_stories#play', as: 'playlist_play_story'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "stories#index"
end
