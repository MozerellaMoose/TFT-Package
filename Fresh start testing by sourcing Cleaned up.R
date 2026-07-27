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


# Api Key
api_key <- Sys.getenv("RIOT_API_KEY")



# Pulling Needed Data Tables:
source("Data/Set 16 Units and Traits.R")
source("Data/Set 17 Units and Traits.R")
source("Data/Region Mapping.R")

# Pulling my functions:
source("Functions/Fancy_Output.R")
source("Functions/Username_Info.R")
source("Functions/Pull Match IDs.R")


# Testing Functions

user_data <- Username_Info("MozerellaMoose") 

Summoner_Name <- user_data[["username"]]
Pull_Match_IDs(api_key, NULL, NULL, 121)

# In case I want to remove functions and values

rm(list = lsf.str())
 # to remove valeues
rm(list = setdiff(ls(), lsf.str()))

