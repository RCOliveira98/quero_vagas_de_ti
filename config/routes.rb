Rails.application.routes.draw do
  devise_for :employees, controllers: {
    registrations: 'employees/registrations'
  }
  root "home#index"
end
