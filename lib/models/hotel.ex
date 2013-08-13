defmodule Airdnp.Hotel do
  use Ecto.Entity
  
  dataset "hotels" do
    field :name, :string
    field :long, :float
    field :lat, :float
  end
end
