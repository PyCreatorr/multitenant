Rails.application.routes.draw do

  resources :tenants do
    resources :boards, only: [:index, :new, :create]

    resources :members do
      collection do # invite_tenant_members POST /tenants/:tenant_id/members/invite(.:format) members#invite
        post :invite # Invite a member to the current tenant
      end
    end
  end

  resources :boards, only: [:show, :edit, :update, :destroy]

  resources :boards, only: [:show] do
    resources :lists, only: [:index, :new, :create]  
  end

  # DEFINE ROUTES FOR :tasks, :lists, :sort  (:show, :edit, :update, :destroy)

  resources :lists, only: [:show] do
    resources :tasks, only: [:index, :new, :create]  
  end

  resources :lists, only: [:show, :edit, :update, :destroy] do
    member do # sort_list PUT /lists/:id/sort(.:format) lists#sort
      put :sort
    end
  end 

  resources :tasks, only: [:show, :edit, :update, :destroy] do
    member do # sort_task PUT /tasks/:id/sort(.:format) tasks#sort
      put :sort
    end
  end

# SEARCH TASKS
# get 'search_friend', to: 'users#search'



  # resources :tasks do
  #   member do # sort_task PUT /tasks/:id/sort(.:format) tasks#sort
  #     put :sort
  #   end
  # end


  # collection do - sort_lists 
  # member do - sort list


  # collection do - invite_tenant_members 
  # member do - invite_tenant_member


  # resources :blog_posts do
  #   resource :cover_image, only: [:destroy], module: :blog_posts
  # end

  # get "/tenants/:tenant_id/boards", to: "boards#index", as: "boards"
  #post "/tenants/:tenant_id/boards", to: "boards#create", as: "boards"

  # post "products/add_to_cart/:id", to: "products#add_to_cart", as: "add_to_cart"

  # devise_for :users
  # devise_for :users, :controllers => { :invitations => 'invitations' }


    devise_for :users, controllers: {
      registrations: "users/registrations"
    }

  put 'boards/users/sidebar_position', to: "preferences#sidebar_position"
  # get 'boards/users/sidebar_position', to: "preferences#get"
  root 'static_pages#landing_page'
  get 'dashboard', to: 'static_pages#dashboard'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
