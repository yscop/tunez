defmodule Tunez.Accounts do
  use Ash.Domain, otp_app: :tunez, extensions: [AshJsonApi.Domain]

  resources do
    resource Tunez.Accounts.Token
    resource Tunez.Accounts.User
  end

  json_api do
    routes do
      base_route"/users", Tunez.Accounts.User do
          post :register_with_password, route: "/register"
      end
    end
  end

end
