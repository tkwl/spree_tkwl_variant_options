Spree::Core::Engine.routes.append do

  namespace :admin do
    resources :option_values do
      member do
        get :detach_image
      end
    end
  end

end
