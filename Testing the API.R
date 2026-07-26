#-------------------- Project: Testing out Riot API to create library ---------- 

# Objective: I want to create a a library that allows new users to easily access
# Data with the Riot's API

# This is more of a testing arena then creating the actual package right now

#  ༼ つ ◕_◕ ༽つ Thanks for using my package
#  ༼ つ ◕_◕ ༽つ Thanks for using my package
#  ༼ つ ◕_◕ ༽つ Thanks for using my package
#  ༼ つ ◕_◕ ༽つ Thanks for using my package


# ------------------- Step 0 Load packages ------------------------------------- 

library(tidyverse) 
# Package for making API requests 
library(httr) 
# needed for the httr2 package
library(curl)
# Package to read the JSON Data 
library(jsonlite) 
# Package to hide Riot API Key 
library(dotenv) 
# Helps with the rate limits for the API Calls 
library(ratelimitr)
# Help clean up some stuff
library(stringr)


# Here I also saved the API Key in a .env file, will probably need to auto do this


# ------------------- Step setting up variables for URLS ----------------------- 


load_dot_env()
api_key <- Sys.getenv("RIOT_API_KEY")

Summoner_Name <- "MozerellaMoose"
tag_line <- "NA1"
region_route <- "https://americas.api.riotgames.com"

# Trying to get a different summoner for more tests
Summoner_Name2 <- "wasianiverson"
tag_line2 <- "NA2"

# Setting up a safe rate limit underneath Riots designated amount

Safe_Limit <- limit_rate(GET, rate(n = 18, period = 1))

# ------------------- Step 1 Testing for a connection/ Getting PUUID -----------

# Creating URL
account_url <- paste0(region_route, "/riot/account/v1/accounts/by-riot-id/", Summoner_Name2, "/", tag_line2)

# Making a request to get the PUUID (Player Universally Unique IDentifiers)
resp_account <- GET(account_url, add_headers(`X-Riot-Token` = api_key))

# Making the response into a readable format
account_data <- content(resp_account, as = "parsed", type = "application/json") %>% 
  as_tibble()

# Grabbing the PUUID
puuid <- account_data$puuid

# ------------------- Step 2 Testing out retrieving Match Data -----------------

# Unsafe amount for riots rate limit
count <- 50

match_ids_url <- paste0(region_route,"/tft/match/v1/matches/by-puuid/",puuid,"/ids?count=",count)

# Pulls the matches
Match_list <- Safe_Limit(match_ids_url, add_headers(`X-Riot-Token` = api_key))
match_ids <- content(Match_list, as = "parsed")





# ------------------- Step 3 reviewing a single match --------------------------

# Getting matches info

Single_Match_Data <- match_ids[1]

Single_Match_URL <- paste0(region_route,"/tft/match/v1/matches/",Single_Match_Data)


Single_Match_Resp <- Safe_Limit(Single_Match_URL, add_headers(`X-Riot-Token` = api_key))

Match_Data <- content(Single_Match_Resp, as = "parsed")



participants_df <- tibble(data = Match_Data$info$participants) %>%
  unnest_wider(data)

# My Own personal exploration into the stats
my_stats <- participants_df %>%
  filter(puuid == !!puuid) %>%
  
  # Companion: single object → wider
  unnest_wider(companion, names_sep = "_") %>%
  
  # Traits: array → longer → wider
  unnest_longer(traits, keep_empty = TRUE) %>%
  unnest_wider(traits, names_sep = "_") %>%
  
  # Units: array → longer → wider
  unnest_longer(units, keep_empty = TRUE) %>%
  unnest_wider(units, names_sep = "_")


participant_core <- participants_df %>%
  filter(puuid == !!puuid) %>%
  unnest_wider(companion, names_sep = "_") %>%
  select(-traits, -units)

traits_df <- participants_df %>%
  filter(puuid == !!puuid) %>%
  select(puuid, traits) %>%
  unnest_longer(traits) %>%
  unnest_wider(traits, names_sep = "_")

units_df <- participants_df %>%
  filter(puuid == !!puuid) %>%
  select(puuid, units) %>%
  unnest_longer(units) %>%
  unnest_wider(units, names_sep = "_") %>%
  mutate(
    # Step 1: replace NULL with empty list
    items_flat = map(units_itemNames, ~ .x %||% list()),
    
    # Step 2: flatten any nested lists inside
    items_flat = map(items_flat, purrr::flatten_chr),
    
    # Step 3: extract up to 3 items
    item1 = map_chr(items_flat, ~ .x[1] %||% NA_character_),
    item2 = map_chr(items_flat, ~ .x[2] %||% NA_character_),
    item3 = map_chr(items_flat, ~ .x[3] %||% NA_character_)
  )%>%
  select(-units_itemNames, -items_flat)

# Conclusion: I'm not quite sure what to do with this information? Maybe 
# I can so something like example tables for the future? But other than the 
# Participant info maybe not the best stuff? But I think it would be cool to
# See what units you lost with/ what comp you lost with and stuff?
# Table this for now and maybe come back to it focus on useful functions.

# ============ Function 1 Pulling PUUID and other useful info ==================










# ---- actually practicing creating a function to 
# ---- pull 500 matches at riots api rate limit 


#'[ Function number 1 is Working!!!]
#'[ Can  Still add some fun stuff like a text box ASCCII with input]

# Pull Match Data

Pull_Match_IDs <- function( puuid = NULL,
                            api_key = NULL,
                            region_route = NULL,
                            n_matches = NULL) {
  
  #-------------- Defaulting data in case user forgets -------------------------
  
  if (is.null(puuid)) {
    message("No puuid input auto inputting one")
    puuid <- "0mbvacPnNM_aBqXhvMrCbjbvnoxPsUljGpmDR6JsLS_bwcJAo7dO_pS5wIXCNt8cbgf8DeH7jUn_-A"
  }
  
  if (is.null(region_route)) {
    message("No region_route input auto inputting NA")
    region_route <- "https://americas.api.riotgames.com"
  }
  
  
  if (is.null(api_key)) {
    api_key <- Sys.getenv("RIOT_API_KEY")
    if (api_key == "") {
      stop("API Key is missing.\n",
           "Input Riot Provided API Key from https://developer.riotgames.com/")
    }
  }
  
  
  if (is.null(n_matches)) {
    message("Number of matches not selected, auto defaulting to 10 most recent")
    n_matches <- 10
  }
  
  if (!is.numeric(n_matches) || n_matches <= 0) {
    stop("n_matches must be a positive number.")
  }
  
  #--------------  Rate limit info so Riot's API doesn't get angry  ------------
  
  safe_limit <- limit_rate(GET, rate(n = 18, period = 1))
  
  chunk_size <- 100
 
  n_requests <- ceiling(n_matches / chunk_size)
  
  #--------------  Chunking the Data  ------------------------------------------
  
  retrieve_chunk <- function(i) {
    start <- (i - 1) * chunk_size
    
    url <- paste0(region_route,
                  "/tft/match/v1/matches/by-puuid/",
                  puuid,
                  "/ids?count=", chunk_size,
                  "&start=", start)
    
    resp <- safe_limit(url, add_headers(`X-Riot-Token` = api_key))
    
    if (status_code(resp) != 200) {
      warning(paste("Request failed at chunk", i , "status:", status_code(resp)))
      return(NULL)
    }
    
    # Make sure it’s a character vector
    ids <- content(resp, as = "parsed")
    if (length(ids) == 0) return(character(0))
    return(as.character(ids))
  }
  
  # Fetch all chunks safely
  match_lists <- map(1:n_requests, retrieve_chunk, .progress = "Fetching Matches")
  
  # Remove NULLs (failed requests) and flatten
  match_ids <- match_lists %>% 
    compact() %>% 
    flatten_chr()
  
  # Trim to n_matches if more returned
  match_ids <- match_ids[1:min(length(match_ids), n_matches)]
  
  return(match_ids)

}


# puuid, api_key, region_route, n_matches = 300, safe_limit = Safe_Limit


Match_History_L <- Pull_Match_IDs(NULL, api_key, NULL ,NULL)



Pull_Match_IDs(NULL, api_key, NULL ,50)


# Function Ideas
# 1. Function that auto connects to server for you, only input API key 
  # Should ask for Summoner_ID,Tagline,Region, and default to NA#1 and NA NA Region 
  #so it can make region url for you


Tft_Stats

# TFTSTATS


Match_Details



Pull_Match_Data()
# For the future if I want to get more than just 200 matches worth of games




# 2. Get player PUUID, Match IDs, Match Details

# 3. Get match data for player

# 4. Plot Placement






# Idea

#' Now that I have the units and traits (Chaos emeralds) I can do something like
#' step 1: Input Summoner name, tag, region (auto populate needed data)
#' step 2: Get the match ID's with the function already created (thanks dylan)
#' step 3: explore a single match or explore a summary of matches
#' step 3.5 clean up the match data so that way you can see what place you ended in
#' Will need to keep multiple players in there and the see at what time you were eliminated
#' and then see what health was left incase two players were eliminated at the same
#' time
#' step 4. maybe auto populate like a last 20 games or something where it populates
#' how well you performed in the last 20 games
#' 
#'


# Testing joining traits onto units with my own trait table
   

units_df <- participants_df %>%
  filter(puuid == !!puuid) %>%
  select(puuid, units) %>%
  unnest_longer(units) %>%
  unnest_wider(units, names_sep = "_") %>%
  mutate(
    # Step 1: replace NULL with empty list
    items_flat = map(units_itemNames, ~ .x %||% list()),
    
    # Step 2: flatten any nested lists inside
    items_flat = map(items_flat, purrr::flatten_chr),
    
    # Step 3: extract up to 3 items
    item1 = map_chr(items_flat, ~ .x[1] %||% NA_character_),
    item2 = map_chr(items_flat, ~ .x[2] %||% NA_character_),
    item3 = map_chr(items_flat, ~ .x[3] %||% NA_character_)
  )%>%
  select(-units_itemNames, -items_flat)


   
Units_With_Traits_Final <- units_df %>%
  #Cleaning up names
  mutate(
    units_character_id = str_remove(units_character_id, "^TFT\\d+_"),
    across(
      c(item1, item2, item3),
      ~ as.character(.x) %>%
        str_remove("^TFT\\d*_Item_") %>%
        str_remove("Item$") %>%
        str_replace_all("(?<=[a-z])(?=[A-Z])", " "))
  ) %>%   select(-c(units_name)) %>% 
  rename(Champion= units_character_id) %>% 
  left_join(Trait_Table_Set16, by= c("Champion")) %>% 
  arrange(item3,item2,item1) %>% 
  rowwise() %>%
  mutate(
    all_traits = list(c(trait1, trait2, trait3, 
                        str_extract(c(item1, item2, item3), ".*(?= Emblem)"))),
    
    all_traits = list(all_traits %>% str_trim() %>% na.omit() %>% .[. != ""])
  ) %>%
  ungroup() %>%
  unnest_wider(all_traits, names_sep = "") %>%
  select(-c(trait1,trait2,trait3)) %>% 
  rename_with(~str_replace(., "all_traits", "trait"))

 
   Traits_Grouped <- Units_With_Traits %>% 
     group_by(trait1) %>% 
     count()
   
   
   Traits_Grouped <- Units_With_Traits %>%
     # Pivot the trait columns into a single "Type" and "Value" column
     pivot_longer(cols = c(trait1, trait2), 
                  names_to = "Trait_Slot", 
                  values_to = "Trait_Name") %>%
     # Group by both the slot (trait1 vs trait2) and the name
     group_by(Trait_Slot, Trait_Name) %>%
     count() %>%
     # Filter out empty traits if necessary
     filter(Trait_Name != "" & !is.na(Trait_Name))
 
   
   Traits_Total_Count <- Units_With_Traits %>%
     pivot_longer(cols = c(trait1, trait2), values_to = "Trait_Name") %>%
     count(Trait_Name) %>%
     filter(Trait_Name != "" & !is.na(Trait_Name))
   
   
 
 # Now I kinda want to look at 50 matches at once to see comps played?
 # Okay so this is units and traits played for the match, now I need match
 # Placement and maybe count of traits? And also add a case when for traits and
 # now I need to add maybe a traits 4 5 and 6 incase their are multiple
 # and i can delete the trait columns incase they aren't used because who wants
   # to see an additional 4 5 and 6 that would be annoyinh
 

   test_units_df <- tibble(
     puuid = "0mbvacPnNM_aBqXhvMrCbjbvnoxPsUljGpmDR6JsLS_bwcJAo7dO_pS5wIXCNt8cbgf8DeH7jUn_-A",
     Champion = c(
       "Lissandra", "Wukong", "Volibear", "Sett", "Illaoi", 
       "JarvanIV", "Shen", "Sejuani", "Sejuani", "Kobuko"
     ),
     units_rarity = c(4, 4, 6, 6, 0, 0, 0, 2, 2, 2),
     units_tier = c(2, 2, 1, 1, 2, 1, 1, 1, 1, 1),
     item1 = c(
       "Archangels Staff", "Warmogs Armor", "Guardian Angel", 
       "Brawler Emblem", "", "", "", "", "Ionia Emblem", ""
     ),
     item2 = c(
       "Archangels Staff", "Dragons Claw", "Steraks Gage", 
       "", "", "", "", "", "Bilgewater Emblem", ""
     ),
     item3 = c(
       "Madreds Bloodrazor", "Red Buff", "Unstable Concoction", 
       "", "", "", "", "", "Noxus Emblem", ""
     ),
     trait1 = c(
       "Freljord", "Ionia", "Freljord", "Ionia", "Bilgewater", 
       "Demacia", "Ionia", "Freljord", "Freljord", "Bruiser"
     ),
     trait2 = c(
       "Invoker", "Bruiser", "Bruiser", "The Boss", "Bruiser", 
       "Defender", "Bruiser", "Defender", "Defender", "Invoker"
     ),
     trait3 = c("", "", "", "", "", "", "", "", "", "")
   )
     
   
   
   
   test_units_df2 <-test_units_df %>% 
     mutate(trait4 = "", trait5 ="", trait6 = "") %>% 
     mutate(
       trait4 = case_when((is.na(trait4) | trait4 == "") & str_detect(item1, "Emblem$") ~ item1,
                          TRUE ~ trait4),
       trait5 = case_when((is.na(trait5) | trait5 == "") & str_detect(item2, "Emblem$") ~ item2,
                          TRUE ~ trait5),
       trait6 = case_when((is.na(trait6) | trait6 == "") & str_detect(item3, "Emblem$") ~ item3,
                          TRUE ~ trait6)
     )
     
  
   
   # How to get the Pre cleaned Data frame straight from the API
   
   participants_df <- tibble(data = Match_Data$info$participants) %>%
     unnest_wider(data)
   
   # Cleaned up data
   
   Units_Cleaned_Up <- tibble(data = Match_Data$info$participants) %>%
     unnest_wider(data) %>% 
     filter(puuid == !!puuid) %>%
     select(puuid, units) %>%
     unnest_longer(units) %>%
     unnest_wider(units, names_sep = "_") %>%
     mutate(
       # Step 1: replace NULL with empty list
       items_flat = map(units_itemNames, ~ .x %||% list()),
       
       # Step 2: flatten any nested lists inside
       items_flat = map(items_flat, purrr::flatten_chr),
       
       # Step 3: extract up to 3 items
       item1 = map_chr(items_flat, ~ .x[1] %||% NA_character_),
       item2 = map_chr(items_flat, ~ .x[2] %||% NA_character_),
       item3 = map_chr(items_flat, ~ .x[3] %||% NA_character_)
     )%>%
     select(-units_itemNames, -items_flat) %>%
     #Cleaning up names
     mutate(
       units_character_id = str_remove(units_character_id, "^TFT\\d+_"),
       across(
         c(item1, item2, item3),
         ~ as.character(.x) %>%
           str_remove("^TFT\\d*_Item_") %>%
           str_remove("Item$") %>%
           str_replace_all("(?<=[a-z])(?=[A-Z])", " "))
     ) %>%   select(-c(units_name)) %>% 
     rename(Champion= units_character_id) %>% 
     left_join(Trait_Table_Set16, by= c("Champion")) %>% 
     arrange(item3,item2,item1) %>% 
     rowwise() %>%
     mutate(
       all_traits = list(c(trait1, trait2, trait3, 
                           str_extract(c(item1, item2, item3), ".*(?= Emblem)"))),
       
       all_traits = list(all_traits %>% str_trim() %>% na.omit() %>% .[. != ""])
     ) %>%
     ungroup() %>%
     unnest_wider(all_traits, names_sep = "") %>%
     select(-c(trait1,trait2,trait3)) %>% 
     rename_with(~str_replace(., "all_traits", "trait"))

   
   
   Pull_Match_IDs(api_key)   
   