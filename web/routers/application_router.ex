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
    user = Airdnp.Db.create(Airdnp.Model.User[name: conn.params[:name], email: conn.params[:email]])
    conn.resp(200, "Success with user_id=#{user.id}") 
  end
end
