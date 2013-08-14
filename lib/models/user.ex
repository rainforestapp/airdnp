defmodule Airdnp.Model.User do
  use Ecto.Entity

  dataset "users" do
    field :zip_code, :string
    field :email, :string
    field :price, :integer

    # field :latitude, :float
    # field :longitude, :float
  end
end
