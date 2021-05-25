defmodule Pollution.Repo do
  use Ecto.Repo,
    otp_app: :pollution,
    adapter: Ecto.Adapters.Postgres
end
