
defmodule Hotwire do
  use HTTPotion.Base

  def process_response_body(body) do
    r = JSEX.decode(to_binary(body))
    {:ok, json} = r
    json
  end
end

Hotwire.start
url = "http://api.hotwire.com/v1/deal/hotel?apikey=g3g7v462pg6b4a25cxn5rhzz&format=json&limit=10&dest=94114&distance=*~30&starrating=4~*&sort=price"

response = Hotwire.get(url)

json = response.body

defrecord Deal, 
  found_date: nil,
  currency_code: nil,
  night_duration: nil,
  end_date: nil,
  headline: nil,
  is_weekend_stay: nil,
  price: nil,
  start_date: nil,
  city: nil,
  country_code: nil,
  neighborhood_latitude: nil,
  neighborhood_longitude: nil,
  neighborhood: nil,
  star_rating: nil,
  state_code: nil

defmodule HotwireParser do
  def result_to_dict([]) do
    []
  end

  def result_to_dict(result) do
    [r | tail] = result
    dict = case r do
      {"FoundDate", val} -> [found_date: val]
      {"CurrencyCode", val} -> [currency_code: val]
      {"NightDuration", val} -> [night_duration: val]
      {"EndDate", val} -> [end_date: val]
      {"Headline", val} -> [headline: val]
      {"IsWeekendStay", val} -> [is_weekend_stay: val]
      {"Price", val} -> [price: val]
      {"StartDate", val} -> [start_date: val]
      {"Url", val} -> [url: val]
      {"City", val} -> [city: val]
      {"CountryCode", val} -> [country_code: val]
      {"NeighborhoodLatitude", val} -> [neighborhood_latitude: val]
      {"NeighborhoodLongitude", val} -> [neighborhood_longitude: val]
      {"Neighborhood", val} -> [neighborhood: val]
      {"StarRating", val} -> [star_rating: val]
      {"StateCode", val} -> [state_code: val]
      _ -> []
    end

    dict ++ result_to_dict(tail)
  end

  def result_to_deal(result) do
    IO.puts inspect(result)
    dict = result_to_dict(result)
    IO.puts inspect(dict)
    deal = Deal.new dict
    deal
  end

  def results_to_deal(results) do
    Enum.map results, fn(x) ->
      result_to_deal(x)
    end
  end

  def extract_results(array) do
    [head | tail] = array
    case head do
      {"Result", results} -> results_to_deal(results)
      _ -> extract_results(tail)
    end
  end
end
 
#IO.puts inspect(json)

res = HotwireParser.extract_results(json)
IO.puts "Results"
IO.puts inspect(res)
