Rails.application.routes.draw do
  concern :votable do
    member do
      patch :upvote
      patch :downvote
    end
  end

  devise_for :users

  resources :users do
    resources :rewards, only: [:index]
  end

  resources :questions, concerns: :votable do
    resources :answers, shallow: true, concerns: :votable, except: %w[index edit] do
      member do
        post 'mark_as_best'
      end
    end
  end

  delete '/attachments/:id/:resource_type/:resource_id', to: 'attachments#destroy', as: :destroy_attachment

  root to: 'questions#index'
end
