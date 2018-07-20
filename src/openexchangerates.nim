## OpenExchangeRates API Client for Nim.
## =====================================
##
## - Get your API Key for Free at https://openexchangerates.org/account/app-ids. Ported from Python.
## - This module should work OK with and without SSL (-d:ssl), API supports both.

import asyncdispatch, json, httpclient, strformat, strutils, times, math

when defined(ssl):
  const base_url = "https://openexchangerates.org/api"  ## SSL is present.
else:
  const base_url = "http://openexchangerates.org/api"   ## SSL Not present.
const
  endpoint_latest = base_url & "/latest.json"
  endpoint_currencies = base_url & "/currencies.json"
  endpoint_historical = base_url & "/historical/"

type
  OpenExchangeRates* = object
    timeout*: int8
    api_key*, base*, local_base*: string
    round_float*, prettyprint*, show_alternative*: bool

template apicall(this: OpenExchangeRates, endpoint: string): untyped =
  let
    q0 = fmt"?app_id={this.api_key.strip}&base={this.base.toUpperAscii.strip}"
    q1 = fmt"&prettyprint={this.prettyprint}&show_alternative={this.show_alternative}"
  # echo endpoint & q0 & q1
  when declared(await):
    result = parseJson(await newAsyncHttpClient().get(endpoint & q0 & q1).body)
  else:
    result = parseJson(newHttpClient(timeout=this.timeout * 1000).get(endpoint & q0 & q1).body)
  # latest and historical has "rates" key with all the data.
  if result.hasKey("rates"):
    result = result["rates"]
    # Local base price conversions.
    if this.local_base != this.base and result.hasKey(this.local_base):
      for key, val in result.pairs:
        result[key] = %round(parseFloat($val) / parseFloat($result[this.local_base]), 8)
    # Round prices to 2 decimals precision.
    if this.round_float:
      for key, val in result.pairs:
        result[key] = %round(parseFloat($val), 2)

proc latest*(this: OpenExchangeRates): JsonNode =
  ## Fetch latest exchange rate data from openexchangerates.
  apicall(this, endpoint_latest)

proc currencies*(this: OpenExchangeRates): JsonNode =
  ## Fetch current currency data from openexchangerates.
  apicall(this, endpoint_currencies)

proc historical*(this: OpenExchangeRates, since_date: DateTime): JsonNode =
  ## Fetch historical exchange rate data from openexchangerates.
  apicall(this, endpoint_historical & since_date.format("yyyy-MM-dd") & ".json")

proc latest_async*(this: OpenExchangeRates): Future[JsonNode] {.async.} =
  ## Fetch latest exchange rate data from openexchangerates.
  apicall(this, endpoint_latest)

proc currencies_async*(this: OpenExchangeRates): Future[JsonNode] {.async.} =
  ## Fetch current currency data from openexchangerates.
  apicall(this, endpoint_currencies)

proc historical_async*(this: OpenExchangeRates, since_date: DateTime): Future[JsonNode] {.async.} =
  ## Fetch historical exchange rate data from openexchangerates.
  apicall(this, endpoint_historical & since_date.format("yyyy-MM-dd") & ".json")


when is_main_module:
  let client = OpenExchangeRates(timeout: 9,
                                 api_key: "",  # Add your api_key here!.
                                 base: "USD",
                                 local_base: "USD",
                                 round_float: true,
                                 prettyprint: true,
                                 show_alternative: true)
  #echo client.latest()
  #echo client.latest_async()
  echo client.currencies()            # Works with and without api_key.
  #discard client.currencies_async()  # Works with and without api_key.
  #echo client.historical(now())
  #echo client.historical_async(now())
