Rails.application.routes.draw do
  concern :votable do
    member do
      patch :upvote
      patch :downvote
    end
  end

  concern :commentable do
    member do
      post :comment
    end
  end

  devise_for :users

  resources :users do
    resources :rewards, only: [:index]
  end

  resources :questions, concerns: [:votable, :commentable] do
    resources :answers, shallow: true, concerns: [:votable, :commentable], except: %w[index edit] do
      member do
        post 'mark_as_best'
      end
    end
  end

  delete '/attachments/:id/:resource_type/:resource_id', to: 'attachments#destroy', as: :destroy_attachment

  root to: 'questions#index'

  mount ActionCable.server => '/cable'
end
