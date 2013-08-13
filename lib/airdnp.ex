defmodule Airdnp do
end

defmodule Airdnp.App do
  use Application.Behaviour

  def start(_type, _args) do
    Airdnp.Sup.start_link
  end
end

defmodule Airdnp.Sup do
  use Supervisor.Behaviour

  def start_link do
    :supervisor.start_link({ :local, __MODULE__ }, __MODULE__, [])
  end

  def init([]) do
    tree = [ worker(Airdnp.Db, []) ]
    supervise(tree, strategy: :one_for_all)
  end
end

defmodule Airdnp.Db do
  use Ecto.Repo, adapter: Ecto.Adapters.Postgres

  def url, do: "ecto://postgres@localhost/airdnp"
end

defmodule Airdnp do
  import Ecto.Query

  def user_query do
    query = from u in Airdnp.User,
      where: u.email != nil,
      select: u

    Airdnp.Db.all(query)
  end
end
