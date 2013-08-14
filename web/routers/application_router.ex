defmodule ApplicationRouter do
  use Dynamo.Router

  prepare do
    # Pick which parts of the request you want to fetch
    # You can comment the line below if you don't need
    # any of them or move them to a forwarded router
    conn.fetch([:cookies, :params])
  end

  # It is common to break your Dynamo in many
  # routers forwarding the requests between them
  # forward "/posts", to: PostsRouter

  get "/" do
    conn = conn.assign(:title, "Welcome to Dynamo!")
    render conn, "index.html"
  end

  get "/mail" do
    deals = Airdnp.Db.all("
      SELECT AVG(price) as avg,
             MAX(price) as max,
             MIN(price) as min,
             start_date

      FROM deals
      WHERE start_date BETWEEN #{conn.params[:start_date]} AND #{conn.params[:end_date]}
      AND zip_code = '#{conn.params[:zip_code]}'
      GROUP BY start_date
      ORDER BY start_date
    ")

    global_deals = hd(Airdnp.Db.all("
      SELECT AVG(price) as avg,
             MAX(price) as max,
             MIN(price) as min,
             start_date

      FROM deals
      WHERE start_date BETWEEN #{conn.params[:start_date]} AND #{conn.params[:end_date]}
      AND zip_code = '#{conn.params[:zip_code]}'
    "))

    data = Enum.reduce(deals, "", fn(string, deal) -> "#{string}#{:io.format(" ~-8s | ~-7s | ~-7s | ~-6s |~n", [deal.start_date, deal.avg, deal.max, deal.min])}\n" end)

    message = "
      Psst!,

      We heard your looking to dynamically adjust your AirBNB rates. Based on our mathematical, algebraic and psychological homework we have determined that the average price per nite this month in your zipcode of #{conn.params[:zip_code]} is $#{global_deals.avg}. With the higest price per night being $#{global_deals.max} and the lowest being $#{global_deals.min}.

      For those of you who prefer to play Eve Online here is a dataset.

      Day      | Average | Highest | Lowest |
      ======================================|
      #{data}

      Your friend,
      Brain Chastity
    "

    conn.resp(200, message)
  end

  post "/signup" do
    params_valid = Enum.reduce([:email, :zip_code, :price], true, fn(param, acc) -> !!conn.params[param] && acc end)
    if params_valid do
      price = elem(String.to_integer(conn.params[:price]),0)
      user = Airdnp.Db.create(Airdnp.Model.User[zip_code: conn.params[:zip_code], price: price, email: conn.params[:email]])

      conn.resp(200, "Thanks, we'll email you soon.")
    else
      conn.resp(200, "Failed, invalid params")
    end
  end
end
