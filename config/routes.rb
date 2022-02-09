# frozen_string_literal: true

Rails.application.routes.draw do
  resources :transactions
  get 'site/index'
  resources :accounts
  devise_for :users
  root to: 'accounts#index'
end
