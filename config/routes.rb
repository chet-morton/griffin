Rails.application.routes.draw do
  root "job_postings#index"

  resources :companies
  resources :candidates, only: [:index, :show]
  resources :analytics, only: [:index]

  resources :job_postings do
    resource :pipeline, only: [:show]
    resources :candidate_matches, only: [:index]
  end

  resources :candidate_applications, only: [:show] do
    member do
      patch :update_stage
    end
    resources :evaluations, only: [:create]
  end

  get "search", to: "search#index"
end
