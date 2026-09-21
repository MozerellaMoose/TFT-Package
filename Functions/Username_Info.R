
Username_Info <- function(Username,
                          Tagline = "NA1",
                          Region = "America",
                          api_key = Sys.getenv("RIOT_API_KEY")) {
  
  if (api_key == "") {
    stop("API Key not found.\nSet it with Sys.setenv(RIOT_API_KEY = '...') or add it to the arguments.")
  }
  
  # Uses the region_Map table to match a region to the correct URL
  routing <- .region_map[tolower(Region)]
  
  #  Adding the region into the url
  region_url <- sprintf("https://%s.api.riotgames.com", routing)
  
  .Fancy_Output(c(
    "Your Input",
    paste("Username:", Username),
    paste("Tagline:", Tagline),
    paste("Region:", Region)
  ))
  
  #  The complete account URL
  account_url <- paste0(region_url, "/riot/account/v1/accounts/by-riot-id/",
                        Username, "/", Tagline)
  
  
  # Creating the API Request
  resp_account <- httr::GET(account_url, httr::add_headers(`X-Riot-Token` = api_key))
  httr::stop_for_status(resp_account)
  
  # Parsing the Data
  account_data <- httr::content(resp_account, as = "parsed", type = "application/json") %>% 
    tibble::as_tibble()
  
  # Getting the PUUID
  puuid <- account_data$puuid
  
  .Fancy_Output(c(
    "You Received",
    paste("PUUID:", puuid)
  ))
  
  # Storing these values for later use
  Information <-(list(
    username = Username,
    tagline = Tagline,
    region = Region,
    puuid = puuid,
    region_url = region_url
  ))
  
  .tft_cache$user <- Information
  
  return(Information)
  
# I'd prefer to return in global environment but that's apparently a no no
}


