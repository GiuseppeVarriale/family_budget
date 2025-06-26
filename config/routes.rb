Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  resource :profile, only: %i[edit update]
  resource :family, only: %i[show new create edit update destroy]
  get 'dashboard', to: 'dashboard#index', as: 'dashboard'
  get 'dashboard/load_overdue_expenses', to: 'dashboard#load_overdue_expenses', as: 'load_overdue_expenses'
  get 'dashboard/load_pending_income', to: 'dashboard#load_pending_income', as: 'load_pending_income'
  get 'dashboard/load_upcoming_expenses', to: 'dashboard#load_upcoming_expenses', as: 'load_upcoming_expenses'
  get 'dashboard/load_upcoming_income', to: 'dashboard#load_upcoming_income', as: 'load_upcoming_income'
  resources :transactions do
    member do
      patch :complete_value
    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get 'service-worker' => 'rails/pwa#service_worker', as: :pwa_service_worker
  get 'manifest' => 'rails/pwa#manifest', as: :pwa_manifest

  # Defines the root path route ("/")
  root 'home#index'
end
