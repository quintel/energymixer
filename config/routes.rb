EnergyMixer::Application.routes.draw do
  devise_for :users

  root :to => "pages#home"

  resources :answers, :only => [:edit, :update, :show, :destroy]

  resources :questions
  resources :dashboard_items
  resources :user_scenarios

  match "/home" => "pages#home"
  match "/mix"  => "pages#mix"
end
