defmodule Airdnp.Db do
  use Ecto.Repo, adapter: Ecto.Adapters.Postgres
  def url, do: System.get_env("DATABASE_URL")
end
