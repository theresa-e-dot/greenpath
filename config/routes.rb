Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  # challenges routues to show on index and show page

  resources :challenges, only: %i[index show]

  resources :challenges do
    resources :habits, only: %i[create]
  end

  # to be finished
  resources :events
end
