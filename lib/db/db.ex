defmodule Airdnp.Db do
  use Ecto.Repo, adapter: Ecto.Adapters.Postgres
  def url, do: "ecto://postgres@localhost/airdnp"
end
