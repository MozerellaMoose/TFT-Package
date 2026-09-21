# Package-internal cache. 
# This is sealed so it will only ever hold what we put in it.
.tft_cache <- new.env(parent = emptyenv())