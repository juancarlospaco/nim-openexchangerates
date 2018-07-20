# nim-openexchangerates

OpenExchangeRates API Client for Nim.

![screenshot](https://source.unsplash.com/ir5MHI6rPg0/800x401 "Photo by https://unsplash.com/@agent_illustrateur")

Worldwide exchange prices + Bitcoin price + Gold price. No dependencies.

This module should work OK with and without SSL `-d:ssl`, API supports both.


# Use

```nim
import openexchangerates

client = OpenExchangeRates(api_key: "21e7c27676972", . . . )
client.latest()
client.currencies()
 . . .
```


# Documentation

<details open >

`openexchangerates(api_key: string, timeout: int8, round_float: bool, base: string, local_base: string)`

**Description:** Returns JSON with current international exchange prices and Bitcoin price.

**Arguments:**
- `api_key` Your API Key, [you can get one API Key for Free](https://openexchangerates.org/account/app-ids), string type.
- `timeout` Timeout on Seconds for network connections, integer 8bits type, optional.
- `round_float` `True` to round floats to 2 decimals, boolean type, optional.
- `base` Base currency, **Only for Pay accounts!**, string type, optional.
- `local_base` Local Base currency, for Free accounts, to calculate values locally (offline), string type, optional.

**Returns:** `JsonNode`.

**Dependencies:** None.

| State              | OS          | Description |
| ------------------ |:-----------:| -----------:|
| :white_check_mark: | **Linux**   | Works Ok    |
| :white_check_mark: | **Os X**    | Works Ok    |
| :white_check_mark: | **Windows** | Works Ok    |

</details>


### Contributors:

- **Please Star this Repo on Github !**, it helps to show up faster on searchs.
- [Help](https://help.github.com/articles/using-pull-requests) and more [Help](https://help.github.com/articles/fork-a-repo) and Interactive Quick [Git Tutorial](https://try.github.io).
- English is the primary default spoken language, unless explicitly stated otherwise *(eg. Dont send Translation Pull Request)*
- Pull Requests for working passing unittests welcomed.


### Licence:

- MIT.


### Ethics and Humanism Policy:

- Religions is not allowed. Contributing means you agree with the COC.
