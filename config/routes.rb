Rails.application.routes.draw do
  devise_for :users, controllers: {
  sessions: "users/sessions",
  registrations: "users/registrations" }

  # Conditional root paths based on user authentication state
  devise_scope :user do
    authenticated :user do
      root to: redirect("loans"), as: :authenticated_root
    end

    unauthenticated do
      root to: "devise/registrations#new", as: :unauthenticated_root
    end

    get "users/sign_out" => "devise/sessions#destroy"
  end

  # Hello world page
  get "hello", to: "home#hello"
  get "loans", to: "properties#loans"
  # Login Route (overriding sessions#new)
  get "login", to: "devise/sessions#new", as: :login

  # Health check route
  get "up" => "rails/health#show", as: :rails_health_check

  # route for displaying customers and their draws
  resources :customers, only: [ :index, :show ]

  # get "loan_portfolio", to: "loans#loan_portfolio"
  #

  resources :loans, only: [ :index, :show ]
  get "/fetch_loans", to: "loans#fetch_and_store_loans_with_history"

  post "fetch_and_save", to: "api_responses#fetch_and_save"
  get "loans/:id/loan_overview", to: "properties#loan_overview", as: :loan_overview
end
