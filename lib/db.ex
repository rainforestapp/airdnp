defmodule Airdnp.Db do
  use Ecto.Repo, adapter: Ecto.Adapters.Postgres

  def url, do: "ecto://postgres@localhost/airdnp"
end

defmodule Airdnp.Db.User do
  import Ecto.Query

  def user_query do
    query = from u in Airdnp.User,
      where: u.email != nil,
      select: u

    Airdnp.Db.all(query)
  end
end
