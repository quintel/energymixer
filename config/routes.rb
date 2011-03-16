EnergyMixer::Application.routes.draw do
  devise_for :users

  root :to => "pages#home"

  resources :answers, :only => [:edit, :update, :show, :destroy]

  resources :questions
  resources :dashboard_items

  match "/home" => "pages#home"
  match "/mix"  => "pages#mix"
end
