defmodule RawSQL do
  import Ecto.Adapters.Postgres
  
  def execute(sql) do
    query(Airdnp.Db, sql)
  end
end

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
      Airdnp.Db.create(Airdnp.Model.Deal[zip_code: elem(String.to_integer(zip_code), 0),start_date: start_date, price: elem(String.to_integer(deal.price), 0), search_id: search_id])
    end)
  end

  def make_search(zip_code) do
    date = :erlang.date()
    formatted_date = "#{elem date, 1}/#{elem date, 2}/#{elem date, 0}" 
    Airdnp.Db.create(Airdnp.Model.Search[zip_code: zip_code, search_date: formatted_date])
  end
end

zip_codes = Airdnp.Collection.User.zip_codes

today = Eldate.today()
dates = Enum.map(Range[first: 0, last: 15], fn(num) ->
  Eldate.shift(today, num, :day)
end)

formatted_dates = Enum.map(dates, fn(date) -> 
  "#{elem date, 1}/#{elem date, 2}/#{elem date, 0}"
end)


Enum.each(zip_codes, fn(zip_code) ->
  search_id = DealPersister.make_search(elem String.to_integer(zip_code), 0).id
  Enum.each(formatted_dates, fn(date) ->
    #DealPersister.persist(zip_code, date, search_id)
    #:timer.sleep(1000)
  end)
  sql = "   
    SELECT AVG(price)::int as avg,
             MAX(price) as max,
             MIN(price) as min,
             start_date

      
      FROM deals
      WHERE search_id = #{search_id} 
      GROUP BY start_date
      ORDER BY start_date
   "
   deals = RawSQL.execute(sql)
   rows = Enum.map(elem(RawSQL.execute(sql), 1), fn(deal) -> {elem(deal, 0), elem(deal, 1), elem(deal, 2), elem(deal, 3)}end)
   final_string = Enum.join(Enum.map(rows, fn(row) -> "#{elem(elem(row, 3),1)}/#{elem(elem(row,3),2)}/#{elem(elem(row,3),0)},#{elem(row,0)},#{elem(row,1)},#{elem(row,2)}"end), "\n")
   
   message = "
      Psst!,

      We heard your looking to dynamically adjust your AirBNB rates. Based on our mathematical, algebraic and psychological homework we have determined the following:

      Day      | Average | Highest | Lowest |
      ======================================|
      #{final_string}

      Your friend,
      Brain Chastity
    "

  Enum.each(Airdnp.Db.all(Airdnp.Collection.User.emails(zip_code)), fn(email) ->
    ElixirSmtp.send!('russ@yourmum.biz', email, 'AirDNP Pricing', message, 'post.c--h.co.uk', 'russ@yourmum.biz', 'THISISAPASSWORD')
  end)
end)
