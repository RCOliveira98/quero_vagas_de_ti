Rails.application.routes.draw do
  
  root "home#index"

  resources :companies, only: %i[index] do
    get 'search_name', on: :collection
    member do
      get 'profile'
      get 'jobs'
    end
  end

  devise_for :candidates

  devise_for :employees, controllers: {
    registrations: 'employees/registrations'
  }
  
  namespace :employees_backoffice do
    root 'home#index'
    resources :employees, only: %i[show edit update]

    resources :jobs, only: %i[index new create show edit update]
    
    resources :companies, only: %i[show edit update] do
      member do
        get 'profile'
      end
    end

    resources :applications, only: %i[index show]
    # decline_applications
    get ':application/decline_applications/new', to: 'decline_applications#new', as: :decline_application
    post ':application/decline_applications/create', to: 'decline_applications#create', as: :decline_applications
    # proposal
    get ':application/proposals/new', to: 'proposals#new', as: :proposal
    post ':application/proposals/create', to: 'proposals#create', as: :proposals

    resources :decline_applications, only: %i[create]
  end

  namespace :candidates_backoffice do
    root 'home#index'
    resources :candidates, only: %i[show edit update]
    resources :applications, only: %i[index show new create edit update]
    resources :jobs, only: %i[show]
  end
end
