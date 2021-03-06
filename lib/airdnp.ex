defmodule Airdnp do
  use Application.Behaviour

  @doc """
  The application callback used to start this
  application and its Dynamos.
  """
  def start(_type, _args) do
    Airdnp.Dynamo.start_link([max_restarts: 5, max_seconds: 5])
    Airdnp.Db.Supervisor.start_link
  end
end
