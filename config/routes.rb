Rails.application.routes.draw do
  resources :tasks
  resources :lists


  resources :tenants do
    resources :members do
      collection do 
        post :invite # Invite a member to the current tenant
      end
    end
  end
  
  # devise_for :users
  devise_for :users, :controllers => { :invitations => 'invitations' }

  root 'static_pages#landing_page'
  get 'dashboard', to: 'static_pages#dashboard'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
