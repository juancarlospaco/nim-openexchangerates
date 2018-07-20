## OpenExchangeRates API Client for Nim.
## =====================================
##
## - Get your API Key for Free at https://openexchangerates.org/account/app-ids. Ported from Python.
## - This module should work OK with and without SSL (-d:ssl), API supports both.

import json, httpclient, strformat, times

when defined(ssl):
  const base_url = "https://openexchangerates.org/api"  ## SSL is present.
else:
  const base_url = "http://openexchangerates.org/api"  ## SSL Not present.
const
  endpoint_latest = base_url & "/latest.json"
  endpoint_currencies = base_url & "/currencies.json"
  endpoint_historical = base_url & "/historical/"

type
  OpenExchangeRates* = object
    timeout*: int8
    api_key*, base*, local_base*: string
    round_float*, html_table_header*: bool

method latest*(this: OpenExchangeRates): JsonNode {.base.} =
  ## Fetch latest exchange rate data from openexchangerates.
  %get(fmt"{endpoint_latest}?app_id={this.api_key}?base={this.base}").body

method currencies*(this: OpenExchangeRates): JsonNode {.base.} =
  ## Fetch current currency data from openexchangerates.
  %get(fmt"{endpoint_currencies}?app_id={this.api_key}?base={this.base}").body

method historical*(this: OpenExchangeRates, since_date: DateTime): JsonNode {.base.} =
  ## Fetch historical exchange rate data from openexchangerates.
  let since_date = since_date.format("yyyy-MM-dd")
  %get(fmt"{endpoint_historical & since_date}?app_id={this.api_key}?base={this.base}").body


when is_main_module:
  let client = OpenExchangeRates(timeout: 9,
                                 api_key: "",
                                 base: "USD",
                                 local_base: "USD",
                                 round_float: true)
  echo client.currencies()
  if client.api_key.len.bool:
    echo client.latest()
