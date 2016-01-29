Rails.application.routes.draw do
  devise_for :users, controllers: { cas_sessions: "simple_cas" }
  root to: "collections#index"

  get "help", to: "help#help"

  get "404", to: "errors#catch_404"
  get "500", to: "errors#catch_500"

  resource :masquerades, only: [:new, :create] do
    get :cancel
  end

  resources :errors

  resources :collections,
            only: [:index, :show, :new, :create, :edit, :update, :destroy] do

    collection do
      get :import_google_sheet_callback, controller: "import"
      get :export_google_sheet_callback, controller: "export"
    end

    member do
      site_setup_constraints = { form: /homepage|collection_introduction|about_text|copyright_text|site_path/ }
      get :site_setup
      get "site_setup/:form", to: "collections#site_setup", as: :site_setup_form, constraints: site_setup_constraints
      put "site_setup/:form", to: "collections#site_setup_update", as: :site_setup_update_form, constraints: site_setup_constraints
      settings_constraints = { form: /general|metadata/ }
      get :settings
      get "settings/:form", to: "collections#settings", as: :settings_form, constraints: settings_constraints
      put "settings/:form", to: "collections#settings_update", as: :settings_update_form, constraints: settings_constraints
      put :publish
      put :unpublish
      post :get_google_import_authorization_uri, controller: "import"
      post :get_google_export_authorization_uri, controller: "export"
    end

    resources :items, only: [:index, :new, :create]
    resources :showcases, only: [:index, :new, :create]
    resources :pages, only: [:index, :new, :create]

    resources :editors, only: [:index, :create, :destroy] do
      collection do
        get :user_search
      end
    end
  end

  resources :items, only: [:edit, :update, :destroy] do
    member do
      put :publish
      put :unpublish
    end
    resources :children, controller: "item_children", only: [:new, :create]
  end

  resources :showcases, only: [:show, :edit, :update, :destroy] do
    member do
      get :title
      put :publish
      put :unpublish
    end
    resources :sections, only: [:index, :new, :create]
  end

  resources :pages, only: [:edit, :update, :destroy]

  resources :sections, only: [:edit, :update, :destroy]

  namespace :v1 do
    resources :collections,
              only: [:show, :index],
              defaults: { format: :json } do
      put :publish, defaults: { format: :json }
      put :unpublish, defaults: { format: :json }
      put :preview_mode, defaults: { format: :json }
      get :metadata_configuration, defaults: { format: :json }
      get :site_objects, defaults: { format: :json }
      put :site_objects, to: "collections#site_objects_update", defaults: { format: :json }
      resources :search, only: [:index], defaults: { format: :json }
      resources :items, only: [:index, :create], defaults: { format: :json }
      resources :showcases, only: [:index], defaults: { format: :json }
      resources :pages, only: [:index], defaults: { format: :json }
    end
    resources :items,
              only: [:show, :update],
              defaults: { format: :json } do
      get :showcases, defaults: { format: :json }
    end
    resources :showcases, only: [:show], defaults: { format: :json }
    resources :pages, only: [:show], defaults: { format: :json }
    resources :sections, only: [:show], defaults: { format: :json }
  end

  namespace :api do
    resources :collections,
              only: [:index, :show],
              constraints: { format: /json/ } do
      resources :items, only: [:index, :show], constraints: { format: /json/ }
    end
  end

  namespace :admin do
    get "/", to: "administration#index"
    resources :external_collections
    resources :administrators, only: [:index, :create, :destroy] do
      collection do
        get :user_search
      end
    end
  end

  scope "/admin_old" do
    resources :users do
      put :set_admin
      put :revoke_admin
    end

    # NOTE About this route.
    # the "ids" that are searched on can have "." in the
    # and that throws off the rails routing. They need to
    # be passed in as query params and not as part of the
    # get string that is not /discovery_test_id/i,adf.adsfwe.adsfsdf
    # but as /discovery_test_id?id=i,adf.adsfwe.adsfsdf
    get "discovery_id_test", to: "discovery_id_test#show"
  end
end
