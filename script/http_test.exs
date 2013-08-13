
defmodule Hotwire do
  use HTTPotion.Base

  def process_response_body(body) do
    IO.puts inspect(body)
    r = JSEX.decode(to_binary(body))
    IO.puts inspect(r)
    r = elem r, 1
    IO.puts inspect(r)
    [_ | json] = r
    [json | _] = json
    json
  end
end

Hotwire.start
url = "http://api.hotwire.com/v1/deal/hotel?apikey=g3g7v462pg6b4a25cxn5rhzz&format=json&limit=10&dest=94114&distance=*~30&starrating=4~*&sort=price"

response = Hotwire.get(url)

IO.puts response.body

