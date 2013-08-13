Dynamo.under_test(Airdnp.Dynamo)
Dynamo.Loader.enable
ExUnit.start

defmodule Airdnp.TestCase do
  use ExUnit.CaseTemplate

  # Enable code reloading on test cases
  setup do
    Dynamo.Loader.enable
    :ok
  end
end
