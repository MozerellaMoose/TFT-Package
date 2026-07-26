#**************************Function Graveyard**********************************

# Creating intial PUUID DataPull
# 
# 
# Username_Info <- function(Username,
#                           tagline = "NA1",
#                           Region = "americas") {
# 
#   if(is.null(tagline)) {
#     tagline  <- "NA1" 
#   }
# 
#   if(Region %in% c("NA", "America", "Americas",
#                    "BR", "Brazil", "Brasil",
#                    "LAN", "LAS")) {
#     Region_Route  <- "https://americas.api.riotgames.com"
#     
#   }
# 
#   if(Region %in% c("EUW", "Europe", "EUNE",
#                    "TR", "RU", "Russia",
#                    "ME")) {
#     Region_Route  <- "europe.api.riotgames.com"
#     
#   }
# 
#   if(Region %in% c("KR", "Korea", "JP", "Japan")) {
#     Region_Route  <- "asia.api.riotgames.com"
#   }
#   
# 
#   if(Region %in% c("OCE", "Oceania", "Australia", 
#                    "PH2", "SG2", "TH2", "TW2", "VN2")) {
#     Region_Route  <- "sea.api.riotgames.com"
#   }
#   
#   Fancy_Output(c(
#     "You Input",
#     paste("Username:", Username),
#     paste("Tagline:", tagline),
#     paste("Region:", Region)
#   ))
#   
#  # This is the URL Riot needs to pull account details
#   account_url <- paste0(Region_Route, "/riot/account/v1/accounts/by-riot-id/",
#                         Username, "/", tagline)
#   
#  # Using the JSON package to make a request to get the PUUID 
#  # (Player Universally Unique IDentifiers)
#   resp_account <- GET(account_url, add_headers(`X-Riot-Token` = api_key))
#   
#   # Making the response into a readable format
#   account_data <- content(resp_account, as = "parsed", type = "application/json") %>% 
#     as_tibble()
#   
#   puuid <- account_data$puuid
#   
#   Fancy_Output(c(
#     "You Recieved",
#     paste("PUUID:", puuid )
#   ))
#   
#   
# } 
# 
# Test <- Username_Info('Seafishy', 'NA1','America')

# Cleaned up versoin of the Username Function