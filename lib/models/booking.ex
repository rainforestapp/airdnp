defmodule Airdnp.Model.Booking do
  use Ecto.Entity

  dataset "bookings" do
    field :price, :integer
    field :start_date, :string
    field :end_date, :string 
    field :hotel_id, :integer 
  end
end
