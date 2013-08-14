defmodule Airdnp.Model.Search do
  use Ecto.Entity

  dataset "searches" do
    field :zip_code, :integer
    field :search_date, :string

    # field :latitude, :float
    # field :longitude, :float
  end
end
