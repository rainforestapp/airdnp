defmodule ApplicationRouterTest do
  use Airdnp.TestCase
  use Dynamo.HTTP.Case

  # Sometimes it may be convenient to test a specific
  # aspect of a router in isolation. For such, we just
  # need to set the @endpoint to the router under test.
  @endpoint ApplicationRouter

  test "index returns 200" do
    conn = get("/")
    assert conn.status == 200
  end

  test "index returns 200" do
    conn = get("/query-prices")
    assert conn.status == 200
  end
end
