defmodule Airdnp.Collection.User do
  use Ecto.Query

  def find_all do
    query = from p in Airdnp.Model.User,
      select: p

    Airdnp.Db.all(query)
  end

  def find(i) do
    query = from p in Airdnp.Model.User,
      where: p.id == i
      select: p

    Airdnp.Db.all(query)
  end
end
