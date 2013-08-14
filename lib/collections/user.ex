defmodule RawSQL do
  import Ecto.Adapters.Postgres
  
  def execute(sql) do
    query(Airdnp.Db, sql)
  end
end

defmodule Airdnp.Collection.User do
  import Ecto.Query

  def find_all do
    query = from p in Airdnp.Model.User,
      select: p

    Airdnp.Db.all(query)
  end

  def find(i) do
    query = from p in Airdnp.Model.User,
      where: p.id == ^i,
      select: p

    hd(Airdnp.Db.all(query))
  end

  def zip_codes do
    Airdnp.Db.all(from user in Airdnp.Model.User, select: user.zip_code) 
  end

  def emails(zip_code) do
    query = from user in Airdnp.Model.User, where: user.zip_code == ^zip_code, select: user.email
  end
end
