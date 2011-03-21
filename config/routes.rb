EnergyMixer::Application.routes.draw do
  devise_for :users

  root :to => "scenarios#new"
  
  namespace :admin do
    resources :answers, :only => [:edit, :update, :show, :destroy]

    resources :questions, :popups
    resources :dashboard_items
    resources :user_scenarios
    
    root :to => "questions#index"
  end

  resources :scenarios, :only => [:new, :create, :show, :index] do
    post :compare, :on => :collection
  end
  
  match "/info/:code", :to => "pages#info"
end
