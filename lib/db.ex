defmodule Airdnp.Db do
  use Ecto.Repo, adapter: Ecto.Adapters.Postgres

  def url, do: "ecto://postgres@localhost/airdnp"
end

defmodule Airdnp.Db.User do
  import Ecto.Query

  def find_all do
    query = from u in Airdnp.Model.User,
      select: u

    Airdnp.Db.all(query)
  end

  # def find(id) do
  #   query = from u in Airdnp.Model.User,
  #     where: u.id == id,
  #     select: u

  #   Airdnp.Db.all(query)
  # end
end
