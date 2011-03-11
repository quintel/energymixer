EnergyMixer::Application.routes.draw do

  devise_for :users

  root :to => "pages#home"

  resources :inputs
  resources :answers, :only => [:edit, :update, :show]
  resources :questions

  match "/home" => "pages#home"
  match "/mix" => "pages#mix"
  match "/httptest" => "pages#httptest"

end
