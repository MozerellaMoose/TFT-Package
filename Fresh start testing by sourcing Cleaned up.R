# Just a clean start from Testing the API by calling functions in this document
# ༼ つ ◕_◕ ༽つ Cleaned upppp

library(tidyverse) 
# Package for making API requests 
library(httr) 
# needed for the httr2 package
library(curl)
# Package to read the JSON Data 
library(jsonlite) 
# Helps with the rate limits for the API Calls 
library(ratelimitr)
# Help clean up some stuff
library(stringr)
#






# New way to save API Key?
source("Functions/Save_Api_Key.R")
#Riot Games Website: https://developer.riotgames.com/


# Api Key
api_key <- Save_Api_Key()

# Pulling Needed Data Tables:
source("Data/Set 16 Units and Traits.R")
source("Data/Set 17 Units and Traits.R")
source("Data/Set 18 Units and Traits.R")
source("Data/Region Mapping.R")

# Pulling my functions:
source("Functions/Fancy_Output.R")
source("Functions/Username_Info.R")
source("Functions/Pull Match IDs.R")

# Cached Files:
source("Functions/Cache.R")


# Testing function Number 2

source("Functions/Pull Match IDs Updated.R")

# Testing Functions

user_data <- Username_Info("MozerellaMoose") 

Summoner_Name <- user_data[["username"]]
#PUUID <- 'YmWjg91S4JeFirU7yreWmB-5XpjafxBfNqV0AbUxrJj8K9LNEk2VNiuRLKO-STfiA0lh2WOmrzyGVg'

Pull_Match_IDs(n_matches =100)

# Testing New Match Function

Test <- Pull_Match_Data(n_matches =75)

# In case I want to remove functions and values

rm(list = lsf.str())
 # to remove valeues
rm(list = setdiff(ls(), lsf.str()))

