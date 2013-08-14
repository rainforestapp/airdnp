
defmodule Hotwire do
  use HTTPotion.Base

  def process_response_body(body) do
    r = JSEX.decode(to_binary(body))
    {:ok, json} = r
    json
  end
end

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
    dict = result_to_dict(result)
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

defmodule DealRetriever do
  def deals_for_zipcode(zip_code, start_date) do
    Hotwire.start
    #start_date = 07/04/1992
    url = "http://api.hotwire.com/v1/deal/hotel?apikey=g3g7v462pg6b4a25cxn5rhzz&format=json&limit=10&startdate=#{start_date}&duration=1&dest=#{zip_code}&distance=*~30&starrating=4~*&sort=price"
    response = Hotwire.get(url)
    json = response.body

    res = HotwireParser.extract_results(json)
    res
  end
end

defmodule DealPersister do
  def persist(zip_code, start_date, search_id) do
    Enum.each(DealRetriever.deals_for_zipcode(zip_code, start_date), fn(deal) -> 
      Airdnp.Db.create(Airdnp.Model.Deal[zip_code: zip_code,start_date: start_date, price: elem(String.to_integer(deal.price), 0), search_id: search_id])
    end)
  end
  
  def make_search(zip_code) do
    date = :erlang.date()
    formatted_date = "#{elem date, 1}/#{elem date, 2}/#{elem date, 0}" 
    Airdnp.Db.create(Airdnp.Model.Search[zip_code: zip_code, search_date: formatted_date])
  end
end

zip_code = 94117
start_date = "08/27/2013"

search_id = DealPersister.make_search(94117).id
DealPersister.persist(zip_code, start_date, search_id)
