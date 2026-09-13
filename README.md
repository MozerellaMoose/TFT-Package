# TFT-Package

An R package focused on helping beginners access Teamfight Tactics data through
Riot's API.

`༼ つ ◕_◕ ༽つ` **Author: MozerellaMoose** `༼ つ ◕_◕ ༽つ`

---

## Introduction: what is this package?

I use R a lot for work and wanted to improve my R skills, so since I love TFT, I
figured I'd mess around with TFT data and do some analysis on my own games.

Before I could start messing with the data, I needed a Riot API key to access their
API. Not having worked with APIs much, I had trouble parsing the data it was all
lists within lists within lists. I also had to follow rules I wasn't accustomed to,
like rate limiting.



After learning how to eventually access the data I decided I should make a package 
that helps beginners access the data in an easy to read 1 row per player per game 
format instead of in lists within lists. The goal is that you type your summoner name,
or any for that matter (I have it preset to Wasianiverson if you don't input one),
and get back a clean tibble of data where the function takes care of the 
routing, rate limiting, paging, unnesting, and mapping.
The data from riot comes with a lot of added information like Ahri will come as 
`DA_18_Ahri` so I change it to `"Ahri"`  so you don't have to worry about that.

---

## Current stage

This R package is still very much a work in progress, and it is at this point 
actually just a list of functions and data together but, I have a few useful 
functions here that I will turn into a package once I refine them some more.

---

## The functions

I have three of main function so far and a lot of little helper functions.


### Function 1: `Save_Api_Key()`

Gets your Riot API key into R without you having to paste it into your script.

```r
Save_Api_Key(key = NULL, persist = FALSE)
```

| Argument | Default | What it does |
|---|---|---|
| `key` | `NULL` | Your Riot API key. Leave it `NULL` and you get a masked prompt instead — nothing echoes to the console. |
| `persist` | `FALSE` | `FALSE` sets the key for this session only. `TRUE` also writes it to `~/.Renviron` so it loads automatically every time R starts. |

**Returns** `TRUE` invisibly. The point is the side effect: `RIOT_API_KEY` gets set in
your environment, and every other function reads from there, so you never have to pass
the key around by hand.

Two small things it does for you. It checks that the key starts with `RGAPI-`, so a typo
or a mis-paste gets you an immediate warning instead of a baffling 403 three functions
later. And when `persist = TRUE`, it strips any existing `RIOT_API_KEY` line before
writing the new one — so re-running it every time your dev key expires replaces the old
key rather than stacking up duplicates.

### Function 2: `Username_Info()`

Turns a summoner name into the identifiers Riot's API actually wants.
For example, you cannot just type in your summoner name and get the match
data, you have to use a specific key given to every account which you
can get from a summoner name but need to put in certain inputs first:


```r
Username_Info(Username,
              Tagline = "NA1",
              Region  = "America",
              api_key = Sys.getenv("RIOT_API_KEY"))
```

| Argument | Default | What it does |
|---|---|---|
| `Username` | *(required)* | Your in-game name — the part before the `#`. |
| `Tagline` | `"NA1"` | The part after the `#`. |
| `Region` | `"America"` | Where you play. Accepts whatever feels natural — `"NA"`, `"euw"`, `"korea"`, `"oce"` — and resolves it for you. |
| `api_key` | env variable | Pulled from `RIOT_API_KEY` automatically. Errors with a useful message if it isn't set. |

**Returns** a named list with five elements:

| Element | What it is |
|---|---|
| `username` | What you passed in |
| `tagline` | What you passed in |
| `region` | What you passed in |
| `puuid` | Your permanent Riot account ID — the thing every other endpoint needs |
| `region_url` | The correct regional base URL, e.g. `https://americas.api.riotgames.com` |

The PUUID is the key output here. Riot's match endpoints don't know anything about
summoner names; they only speak PUUID. So this function is the bridge between what you
call yourself and what the API calls you.

### Function 3: `Pull_Match_IDs()`

Takes a PUUID and gives you back a list of match IDs.

```r
Pull_Match_IDs(api_key      = NULL,
               puuid        = NULL,
               region_route = NULL,
               n_matches    = NULL)
```

| Argument | Default | What it does |
|---|---|---|
| `api_key` | env variable | Falls back to `RIOT_API_KEY`. Errors if that's empty too. |
| `puuid` | *(see rough edges)* | The PUUID from `Username_Info()`. |
| `region_route` | `americas` | The regional base URL — pass `user_data$region_url`. |
| `n_matches` | `10` | How many matches you want. Ask for more than 100 and it pages for you. |

**Returns** a character vector of match IDs, tagged with the class `riot_match_list` so
it prints nicely instead of flooding your console.

Note the argument order `api_key` comes **first**, not `puuid`. Naming your arguments
explicitly, as in the example below, sidesteps the issue entirely, and I'd recommend
doing that.

---

## Supporting pieces

- **Region mapping** (`Data/Region Mapping.R`) — you type `"NA"`, `"euw"`, `"korea"`,
  whatever feels natural, and it resolves to the right routing value. Riot uses four
  routes (`americas`, `europe`, `asia`, `sea`) and nobody remembers which one Oceania
  lives on. (It's `sea`.)
- **Trait tables** for Sets 16, 17, and 18 (`Data/`) — the API returns unit IDs, not
  names, and the naming scheme changes between sets. Set 18 in particular moved from
  `TFT18_Name` to `DA_18_Name` / `DA_Name18` when Riot migrated to Unreal, so these
  tables are hand-maintained lookups built from Data Dragon / CommunityDragon.
- **`.Fancy_Output()`** — draws a little box around console output. Purely cosmetic.
  Absolutely staying.

---

## Getting started

You'll need a Riot API key from [developer.riotgames.com](https://developer.riotgames.com/).
The free development key expires every 24 hours, which is annoying but fine for messing
around.

```r
library(tidyverse)
library(httr)
library(curl)
library(jsonlite)
library(ratelimitr)
library(stringr)

# Load everything
source("Functions/Save_Api_Key.R")
source("Functions/Fancy_Output.R")
source("Functions/Username_Info.R")
source("Functions/Pull Match IDs.R")
source("Data/Region Mapping.R")
source("Data/Set 18 Units and Traits.R")

# Stash your key (persist = TRUE writes it to ~/.Renviron)
Save_Api_Key()

# Who are you?
user_data <- Username_Info("MozerellaMoose", Tagline = "NA1", Region = "America")

# Grab your last 100 games
matches <- Pull_Match_IDs(
  puuid        = user_data$puuid,
  region_route = user_data$region_url,
  n_matches    = 100
)
```

Or just open `Fresh start testing by sourcing Cleaned up.R`, which sources everything and
runs the whole flow top to bottom. 

If you are having trouble sourcing them, make sure you are in the correct
working directory.

Your API key is read from the `RIOT_API_KEY` environment variable, and `.Renviron` is in
`.gitignore`, so the key never ends up in the repo.

---

## Small details

**The rate limiter.** Riot's development keys allow 20 requests per second and they will
absolutely 429 you if you blow past it. `Pull_Match_IDs()` wraps `GET()` in
`ratelimitr::limit_rate()` at 18/second — deliberately under the ceiling — so you can ask
for 500 matches and walk away instead of babysitting it.

**Chunking.** The match-IDs endpoint maxes out at 100 per request, so asking for more than
that means paging. `Pull_Match_IDs()` works out how many requests it needs, fires them
with a progress bar, drops anything that failed, flattens the result, and trims to exactly
the count you asked for.

**The print method.** Pull 500 match IDs and R will happily vomit all 500 into your
console. So match ID vectors get a `riot_match_list` class with a custom `print()` that
shows the first 10 and then says `... and 490 more matches.`

---

## Where this is going

The current functions get you *to* the data. The next chunk of work is doing something
with it once it's there:

- [ ] **`Pull_Match_Data()`** — take those match IDs and fetch the full match detail for
      each one.
- [ ] **Unnest and clean the participant data** — the raw response has units, traits, and
      items buried in nested lists. I've got working `unnest_longer()` / `unnest_wider()`
      code for this sitting in `Testing the API.R`; it needs to become a real function.
- [ ] **Join the trait tables** so unit IDs become champion names with their traits
      attached — including pulling trait names out of Emblem items, since an emblem
      effectively grants a trait the unit doesn't natively have.
- [ ] **Placement analysis** — where you finished, when you got eliminated, and how much
      health you had left (that last one matters for breaking ties when two players die on
      the same round).
- [ ] **A "last 20 games" summary** — one call, one table, how you've actually been doing.
- [ ] **Comp analysis across many matches** — what am I actually playing, and what's
      actually working?
- [ ] **Turn this into a real installable package** — `DESCRIPTION`, `NAMESPACE`, roxygen
      docs, the works.

---

## Currently working on 


- I am actually working on making this into a package so you don't have to go through
- all the annoying trouble of sourcing it. If you go through some of my code you can
- also see I am working on cleaning up the names and found a couple cool work
- arounds to get multiple traits shown for a character at the same time.
- Like if a character had 3 traits already(Tristana this set) and then someone
- decides to put 3 additional traits on them. It might show up janky but with
- what I currently have in the code it should fix it.

- I'm sure with this new set asa well with the consumables that will cause issues
- with how some of the data is presented so I have to look into that.

- I want to also make some summaries of comps played by grouping the traits all together.
- I forsee an issue if someone has two of the same units on the board but I am currently
- working on a fix for that as well.

---

## Repo layout

```
Functions/     The actual functions. This is the real code.
Data/          Region mapping + per-set unit/trait lookup tables.
Graveyard/     Old versions of functions I'm not ready to delete yet.

Testing the API.R                              My scratchpad. Messy on purpose.
making function more lean.R                    Refactoring notes.
Fresh start testing by sourcing Cleaned up.R   The clean entry point.
```

The `Graveyard` folder is commented-out previous attempts. I keep them because about a
third of the time the old approach turns out to have been right.

---

## Built with

`tidyverse` (`dplyr` · `purrr` · `tibble` · `stringr`) · `httr` · `curl` · `jsonlite` ·
`ratelimitr` · `askpass`

---

This project isn't endorsed by Riot Games and doesn't reflect the views or opinions of
Riot Games or anyone officially involved in producing or managing Riot Games properties.
Riot Games and all associated properties are trademarks or registered trademarks of Riot
Games, Inc.
