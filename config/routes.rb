EnergyMixer::Application.routes.draw do
  devise_for :users

  root :to => "pages#home"

  namespace :admin do
    resources :answers, :only => [:edit, :update, :show, :destroy]

    resources :questions, :popups, :question_sets
    resources :dashboard_items
    resources :scenarios do
      get :stats, :on => :collection
      get :analysis, :on => :collection
      post :analysis, :on => :collection
    end
    resources :translations

    resources :pages, :only => :index

    match 'reset_cache' => 'pages#reset_cache', :as => :reset_cache

    root :to => "pages#index"
  end

  resources :scenarios, :path => 'mixes', :only => [:new, :create, :show, :index] do
    post :compare, :on => :collection
    get :answers,  :on => :member
  end

  match "/info/:code", :to => "pages#info"
  match "/stats", :to => "pages#stats"
end
