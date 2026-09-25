
#---- Cleaning Up the match ----

# Works with on one match at a time for the moment.
# Current Ideas, definetly want summoner name on the front...
# Good for one match but should find a way to scale it to multiple matches? Although
# That may be hard to view, also its just one players pov at the moment. Nice to see
# as a one player viewing their own stats, but as everyone in the lobby, would get really messy.
# one player has 8 units in this one, could have up to 80 units or more if lobby is all lvl 10.

# -- Probably change units_rarity and units_tier to better names (cost and star level or something)
# -- FOR SURE need to clean up brawler and other old names in this.
# -- Move 

Test <- Pull_Match_Data(n_matches =15)


# Single Match Data
Single_Match_Data <- Test %>% filter(game_number == 1)



.Trait_Table_All <- bind_rows(
  list(Set16 = .Trait_Table_Set16,
       Set17 = .Trait_Table_Set17,
       Set18 = .Trait_Table_Set18),
  .id = "trait_set"
)



.clean_item_name <- function(x) {
  x %>%
    str_remove("^(TFT\\d*_Item_|TFT\\d*_|DA_Item_|DA_\\d+_|DA_)") %>%  # any known prefix
    str_remove("Item$") %>%                                            # trailing 'Item'
    str_replace_all("_", " ") %>%                                      # Snake_Case -> spaces
    str_replace_all("(?<=[a-z])(?=[A-Z])", " ") %>%                    # camelCase -> camel Case
    str_replace_all("(?<=[A-Z])(?=[A-Z][a-z])", " ") %>%               # NOVAEmblem -> NOVA Emblem
    str_squish()
}


#---------------- Pulling the trait out of an emblem (either word order) -------

.emblem_trait <- function(x) {
  coalesce(
    str_extract(x, "^.+(?= Emblem$)"),   # old style:  "Ionia Emblem"  -> "Ionia"
    str_extract(x, "(?<=^Emblem ).+$")   # new style:  "Emblem Hunter" -> "Hunter"
  )
}




Units_Cleaned_Up_Test6 <- Single_Match_Data %>%
  filter(puuid == .tft_cache$user$puuid) %>%
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
  ) %>%
  select(-units_itemNames, -items_flat) %>%
  # Cleaning up item names (handles both TFT_ and DA_ styles)
  mutate(across(c(item1, item2, item3), .clean_item_name)) %>%
  select(-c(units_name)) %>%
  # Join on the raw id, against every set's table at once
  left_join(.Trait_Table_All, by = "units_character_id") %>%
  relocate(trait_set, puuid, Champion) %>%
  arrange(item3, item2, item1) %>%
  rowwise() %>%
  mutate(
    all_traits = list(c(trait1, trait2, trait3,
                        .emblem_trait(c(item1, item2, item3)))),
    
    all_traits = list(all_traits %>% str_trim() %>% na.omit() %>% .[. != ""])
  ) %>%
  ungroup() %>%
  unnest_wider(all_traits, names_sep = "") %>%
  select(-c(trait1, trait2, trait3)) %>%
  rename_with(~ str_replace(., "all_traits", "trait"))
