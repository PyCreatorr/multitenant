Rails.application.routes.draw do
  resources :tasks
  resources :lists do
    member do # sort_list PUT /lists/:id/sort(.:format) lists#sort
      put :sort
    end
  end 

  # collection do - sort_lists 
  # member do - sort list


  resources :tenants do
    resources :members do
      collection do # invite_tenant_members POST /tenants/:tenant_id/members/invite(.:format) members#invite
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
