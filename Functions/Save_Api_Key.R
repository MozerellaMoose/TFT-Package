Save_Api_Key <- function(key = NULL, persist = FALSE) {
  if (is.null(key)) {
    prompt <- paste0(
      "Riot API key\n",
      "Get one at https://developer.riotgames.com/"
    )
    key <- askpass::askpass(prompt)
  }
  if (!grepl("^RGAPI-", key)) warning("That doesn't look like a Riot API key.")
  
  Sys.setenv(RIOT_API_KEY = key)
  
  if (persist) {
    path  <- path.expand("~/.Renviron")
    lines <- if (file.exists(path)) readLines(path) else character()
    lines <- lines[!grepl("^RIOT_API_KEY=", lines)]
    writeLines(c(lines, paste0("RIOT_API_KEY=", key)), path)
    message("Key saved to ~/.Renviron and set for this session.")
  } else {
    message("Key set for this session only.")
  }
  invisible(TRUE)
}
