EnergyMixer::Application.routes.draw do
  devise_for :users

  root :to => "pages#home"

  resources :answers, :only => [:edit, :update, :show, :destroy]

  resources :questions
  resources :dashboard_items
  resources :user_scenarios

  match "/home"          => "pages#home"
  match "/scenario/:id"  => "pages#scenario", :as => :scenario
  match "/save_scenario" => "pages#save_scenario", :as => :save_scenario
end
