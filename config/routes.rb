EnergyMixer::Application.routes.draw do
  devise_for :users

  root :to => "pages#home"
  
  namespace :admin do
    resources :answers, :only => [:edit, :update, :show, :destroy]

    resources :questions, :popups
    resources :dashboard_items
    resources :scenarios
    
    root :to => "questions#index"
  end

  resources :scenarios, :path => 'mixes', :only => [:new, :create, :show, :index] do
    post :compare, :on => :collection
    get :answers,  :on => :member
  end
  
  match "/info/:code", :to => "pages#info"
end
