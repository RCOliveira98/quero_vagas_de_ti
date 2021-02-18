Rails.application.routes.draw do
  root "home#index"

  devise_for :employees, controllers: {
    registrations: 'employees/registrations'
  }
  namespace :employees_backoffice do
    resources :employees, only: %i[show edit update]

    resources :jobs, only: %i[index new create show edit update]
    
    resources :companies, only: %i[show edit update] do
      member do
        get 'profile'
      end
    end
  end
end
