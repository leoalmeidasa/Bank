# frozen_string_literal: true

Rails.application.routes.draw do
  get 'transference/new'
  resources :transactions
  get 'site/index'
  resources :accounts
  devise_for :users
  root to: 'accounts#index'
end
