
Fancy_Output <- function(lines) {
  width <- max(nchar(lines)) + 5
  top <- paste0("╭", paste(rep("─", width), collapse=""), "╮")
  bot <- paste0("╰", paste(rep("─", width), collapse=""), "╯")
  
  cat(top, "\n")
  for (l in lines) {
    cat(sprintf("│ %-*s │\n", width -2, l))
  }
  cat(bot, "\n")
}


# Testing it fancy_box(c("Your Input:", "Result = 12", "R"))

retrieve_chunk <- function(i, puuid, region_route, api_key, chunk_size, safe_limit) {
  start <- (i - 1) * chunk_size
  
  url <- paste0(region_route,
                "/tft/match/v1/matches/by-puuid/",
                puuid,
                "/ids?count=", chunk_size,
                "&start=", start)
  
  # Using the passed-in safe_limit and api_key
  resp <- safe_limit(url, add_headers(`X-Riot-Token` = api_key))
  
  if (status_code(resp) != 200) {
    warning(paste("Request failed at chunk", i , "status:", status_code(resp)))
    return(NULL)
  }
  
  ids <- content(resp, as = "parsed")
  return(as.character(ids))
}


Pull_Match_IDs <- function( api_key = NULL,
                            puuid = NULL,
                            region_route = NULL,
                            n_matches = NULL) {
  #-------------- Creating a fancy Ouput ---------------------------------------
  
  
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
  
  Fancy_Output(c(
    "Starting Match Pull",
    paste("PUUID:", puuid),
    paste("Region:", region_route),
    paste("Matches Requested:", n_matches)
  ))
  
  
  #--------------  Rate limit info so Riot's API doesn't get angry  ------------
  
  safe_limit <- limit_rate(GET, rate(n = 18, period = 1))
  
  chunk_size <- 100
  
  n_requests <- ceiling(n_matches / chunk_size)
  
  #--------------  Chunking the Data  ------------------------------------------
  
  
  
  # Fetch all chunks safely
  match_lists <- map(1:n_requests, ~{
    retrieve_chunk(
      i = .x, 
      puuid = puuid, 
      region_route = region_route, 
      api_key = api_key, 
      chunk_size = chunk_size, 
      safe_limit = safe_limit
    )
  }, .progress = "Fetching Matches")
  
  # Remove NULLs (failed requests) and flatten
  match_ids <- match_lists %>% 
    compact() %>% 
    flatten_chr()
  
  # Trim to n_matches if more returned
  match_ids <- match_ids[1:min(length(match_ids), n_matches)]
  
  
  Fancy_Output(c(
    "Success!",
    paste("Matches Retrieved:", length(match_ids))
  ))
  
  
  return(match_ids)
  
}


Pull_Match_IDs(api_key)


