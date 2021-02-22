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
  end

  namespace :candidates_backoffice do
    root 'home#index'
    resources :candidates, only: %i[show edit update]
    resources :applications, only: %i[index show new create edit update]
    resources :jobs, only: %i[show]
  end
end
