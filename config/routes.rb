Rails.application.routes.draw do
  devise_for :admins

  resources :reports, only: [:create, :destroy, :index, :new, :show] do
    member do
      post :new
    end
  end
  #devise_for :admins
  resources :reports
  get '/arkiv' => 'reports#arkiv'

  resources :playlists, only: [:create, :destroy, :index, :new, :show] do
    member do
      post :new
    end
  end
  post "cancel_playlist_form", to:"playlists#cancel", as: 'cancel_playlist_form'
  resources :playlist_stories, only: [:create, :destroy]
  get 'my_stories', to: 'playlists#my_stories', as: "my_stories"
  get 'my_favourites', to: 'playlists#my_favourites', as: "my_favourites"
  get 'playlist/play/:id', to: 'playlists#play', as: 'playlist_play'
  get 'playlist/:playlist_id/:id', to: 'playlist_stories#play', as: 'playlist_play_story'

  scope '(:locale)' do
    resources :favourites
    devise_for :users, :controllers => { :registrations => 'registrations' }
    resources :stories
    resources :likes, only: [:create, :destroy]
    resources :dislikes, only: [:create, :destroy]
    get 'my_stories', to: 'stories#my_stories'
    get 'play/:id', to: 'stories#play', as: 'play'

    post 'profiles/:id/stories', to: 'profiles#stories', as: 'profile_stories'
    post 'profiles/:id/playlists', to: 'profiles#playlists', as: 'profile_playlists'
    get 'profiles/:id', to: "profiles#index", as: 'profile'

    # Defines the root path route ("/")
    root "stories#index"

  end
end
