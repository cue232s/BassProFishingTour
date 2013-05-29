BpsFishingTour::Application.routes.draw do
    # match '/' => redirect('/login'), via: :get

    get '/thanks' => 'static_pages#thanks'
    get '/confirm' => 'static_pages#confirm'


    devise_for :users, controllers: {
        registrations: 'registrations',
        confirmations: 'confirmations'
    }

    authenticated :user do
        # root :to => "main#dashboard", as: :user_root
    end

    resources :profiles
    root to: 'static_pages#home'
    resources :teams
    match '/teams' => 'teams#index', via: :get
    match '/teammate/search' => 'teams/requests#search', as: 'invite_teammate', via: :post
    match '/teammate/send_invite' => 'teams/requests#send_invite', as: 'send_invite', via: :get
    match '/teammate/invite_response/:id' => 'teams/requests#respond_to_invite', as: 'invite_response', via: :get

    scope '/teams' do
        match '/requests/new' => 'teams/requests#new', via: :get
    end
end
