Rails.application.routes.draw do
  devise_for :users

  resources :users do
    resources :rewards, only: [:index]
  end

  resources :questions do
    resources :answers, shallow: true, except: %w[index edit] do
      member do
        post 'mark_as_best'
      end
    end
  end

  delete '/attachments/:id/:resource_type/:resource_id', to: 'attachments#destroy', as: :destroy_attachment

  root to: 'questions#index'
end
