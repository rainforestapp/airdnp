defmodule Airdnp.Db.Sup do
  use Supervisor.Behaviour

  def start_link do
    :supervisor.start_link({ :local, __MODULE__ }, __MODULE__, [])
  end

  def init([]) do
    tree = [ worker(Airdnp.Db, []) ]
    supervise(tree, strategy: :one_for_all)
  end
end
