Save_Api_Key <- function(key, persist = TRUE) {
  Sys.setenv(RIOT_API_KEY = key)
  
  if (persist) {
    path  <- path.expand("~/.Renviron")
    lines <- if (file.exists(path)) readLines(path) else character()
    lines <- lines[!grepl("^RIOT_API_KEY=", lines)]   # drop the old entry
    writeLines(c(lines, paste0("RIOT_API_KEY=", key)), path)
    message("Key saved to ~/.Renviron and set for this session.")
  } else {
    message("Key set for this session only.")
  }
  
  invisible(TRUE)
}

