BpsFishingTour::Application.routes.draw do

    resources :scores do
        collection { post :import }
    end
    get 'scores/angler/:id/:angler_id' => 'scores#angler'
    get 'scores/co_angler/:id/:co_angler_id' => 'scores#co_angler'
    get '/score/remove-angler' => 'scores#remove_angler'
    get 'score/remove-co-angler' => 'scores#remove_co_angler'

    # Static Page Routing
    root to: 'static_pages#home'
    %w[thanks about confirm help].each do |page|
        get page, controller: 'static_pages', action: page
    end

    get '/select_profile_picture' => 'profiles#select_profile_pic'
    post '/upload_profile_pic' => 'profiles#upload_profile_pic'
    get'/team_select_profile_picture' => 'teams#select_profile_pic'
    post '/upload_team_pic' => 'teams#upload_team_pic'
    # Profile Routing
    get '/myprofile' => 'profiles#show_current', as: 'my_profile'
    get '/profiles', to: redirect('/anglers')
    get '/profiles/completion-reminder' => 'profiles#completion_reminder'
    resources :profiles


    # Event Routing
    resources :events
    match '/events/:id/attend' => 'events#register_event', as: 'register_event', via: :post
    match '/events/:id/unattend' => 'events#unregister_event', as: 'unregister_event', via: :post
    get '/events' => 'events#index', as: 'events_path'
    get '/event-scores/:id' => 'events#event_scores', as: :event_scores, via: :get
    post '/events/:id/merge' => 'events#merge', as: :event_merge, via: :post
    # Authentication Routing
    devise_for :users, controllers: {
        registrations: 'registrations',
        confirmations: 'confirmations'
    }

    get '/join', to: redirect('/users/sign_up')

    # Team Routing
    get '/teams', to: redirect('/leaderboard')
    match '/teammate/send_invite' => 'teams/requests#send_invite', as: 'send_invite', via: :post
    match '/teammate/invite_response/:id' => 'teams/requests#respond_to_invite', as: 'invite_response', via: :get
    match '/teammate/accept_invite/:request_id' => 'teams/requests#accept_invitation', as: 'accept_invite', via: :get
    match '/teammate/reject_invite' => 'teams/requests#reject_invitation', as: 'reject_invite', via: :get

    match '/users/:id/team_invitations' => 'teams/requests#team_invitations', as: 'team_invitations', via: :get
    scope '/teams' do
        match '/requests/new' => 'teams/requests#new', via: :get
        get '/requests/invite-reminder' => 'teams/requests#invite_reminder'
    end

    resources :teams

    # Anglers Routing
    get '/anglers' => 'anglers#index'

    # Leaderboard Routing
    get '/leaderboard' => 'leaderboard#index'

    # News Routing
    get '/news' => 'news#index'
    get '/news/:year/:month/:day/:title' => 'news#story'

    # Secret Admin Routing
    get '/admin/users-report' => 'admin#users_report'
    get '/admin/users-table' => 'admin#users_table', as: 'user_report'
    get '/admin/team-table' => 'admin#team_table', as: 'team_table'
end
