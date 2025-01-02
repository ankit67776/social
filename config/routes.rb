Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "users/registrations" }

  # Conditional root paths based on user authentication state
  devise_scope :user do
    authenticated :user do
      root to: redirect("/hello"), as: :authenticated_root
    end

    unauthenticated do
      root to: "devise/registrations#new", as: :unauthenticated_root
    end
  end

  # Hello world page
  get "hello", to: "home#hello", as: "hello"

  # Login Route (overriding sessions#new)
  get "login", to: "devise/sessions#new", as: :login

  # Health check route
  get "up" => "rails/health#show", as: :rails_health_check
end
