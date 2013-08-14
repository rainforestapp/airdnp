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

  post "/query-prices" do
    params_valid = Enum.reduce([:email, :zip_code, :price], true, fn(param, acc) -> !!conn.params[param] && acc end)
    if params_valid do
      user = Airdnp.Db.create(Airdnp.Model.User[zip_code: conn.params[:zip_code], price: conn.params[:price], email: conn.params[:email]])
      
      Airdnp.Db.find_all(Airdnp.Model.Search[zip_code: conn.params[:zip_code]]) 
      
      conn.resp(200, "Success with user_id=#{user.id}") 
    else
      conn.resp(200, "Failed, invalid params")
    end
  end
end
