Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :collages, only: [:create] do
    get "/status", to: "collages#status"
  end

  Sidekiq::Web.use(Rack::Auth::Basic) do |username, password|
    # username == Rails.application.credentials[Rails.env.to_sym][:sidekiqweb][:username] &&
    # password == Rails.application.credentials[Rails.env.to_sym][:sidekiqweb][:password]
    ActiveSupport::SecurityUtils.secure_compare(username, Rails.application.credentials[:sidekiq][:username]) &&
      ActiveSupport::SecurityUtils.secure_compare(password, Rails.application.credentials[:sidekiq][:password])
  end

  mount(Sidekiq::Web => "/sidekiq")
end
