# frozen_string_literal: true

Rails.application.routes.draw do
  resources :accounts
  devise_for :users
  root to: 'accounts#index'
end
