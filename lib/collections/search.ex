defmodule Airdnp.Collection.Search do
  import Ecto.Query

  def find_by_zip(i) do
    query = from p in Airdnp.Model.Search,
      where: p.zip_code == ^i,
      order_by: [p.search_date]
  end
end
