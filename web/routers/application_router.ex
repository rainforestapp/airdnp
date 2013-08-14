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
