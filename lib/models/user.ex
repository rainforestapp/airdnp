defmodule Airdnp.User do
  use Ecto.Entity

  dataset "users" do
    field :name, :string
    field :email, :string
    # field :latitude, :float
    # field :longitude, :float
  end
end
