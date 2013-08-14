defmodule Airdnp.Model.Deal do
  use Ecto.Entity

  dataset "deals" do
    field :start_date, :string
    field :zip_code, :integer 
    field :search_id, :integer

    field :price, :integer
    
    field :found_date, :string
    field :currency_code, :string
    field :night_duration, :string
    field :headline, :string
    field :is_weekend_stay, :string
    field :city, :string
    field :country_code, :string
    field :neighborhood_latitude, :string
    field :neighborhood_longitude, :string
    field :neighborhood, :string
    field :star_rating, :string
    field :state_code, :string
  end
end
