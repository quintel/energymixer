EnergyMixer::Application.routes.draw do
  devise_for :users

  root :to => "scenarios#new"

  resources :answers, :only => [:edit, :update, :show, :destroy]

  resources :questions
  resources :dashboard_items
  resources :user_scenarios
  resources :scenarios, :only => [:new, :create, :show, :index] do
    post :compare, :on => :collection
  end
end
