defmodule Precider.Repo do
  use Ecto.Repo,
    otp_app: :precider,
    adapter: Ecto.Adapters.Postgres
end
