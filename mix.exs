defmodule Airdnp.Mixfile do
  use Mix.Project

  def project do
    [ app: :airdnp,
      version: "0.0.1",
      dynamos: [Airdnp.Dynamo],
      compilers: [:elixir, :dynamo, :app],
      env: [prod: [compile_path: "ebin"]],
      compile_path: "tmp/#{Mix.env}/airdnp/ebin",
      deps: deps ]
  end

  # Configuration for the OTP application
  def application do
    [ applications: [:cowboy, :dynamo],
      mod: { Airdnp, [] } ]
  end

  defp deps do
    [ { :cowboy, github: "extend/cowboy" },
      { :dynamo, "0.1.0-dev", github: "elixir-lang/dynamo" },
      { :ecto, github: "elixir-lang/ecto" },
      { :pgsql, github: "semiocast/pgsql" },
      { :httpotion, github: "myfreeweb/httpotion" },
      { :jsex, github: "talentdeficit/jsex" }
    ]
  end
end
