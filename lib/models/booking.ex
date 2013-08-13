defmodule Airdnp.Model.Booking do
  use Ecto.Entity

  dataset "bookings" do
    field :price, :int
    field :start_date, :datetime
    field :end_date, :datetime 
    field :hotel_id, :int 
  end
end
