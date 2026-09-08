# TFT Set 18 Enchanted Wilds champion/trait look-up table
# Note: with Set 18 (Unreal Engine migration) Riot changed unit ids from the
# "TFT18_Name" pattern to "DA_18_Name" / "DA_Name18". Ids below are the apiName
# values from Data Dragon / CommunityDragon. Lux appears once per Avatar origin.

.Trait_Table_Set18 <- data.frame(
  units_character_id = c(
    "DA_18_Ahri", "DA_18_Akali_AD", "DA_18_Alistar", "DA_18_Alune", "DA_Amumu18", "DA_18_Aphelios",
    "DA_18_Ashe", "DA_18_Azir", "DA_Brambleback18", "DA_18_Caitlyn", "DA_18_Camille", "DA_18_Cassiopeia",
    "DA_Cinderling18", "DA_18_Diana", "DA_Draven18", "DA_18_ElderDragon", "DA_18_Elise", "DA_18_Ezreal",
    "DA_Fiddlesticks18", "DA_18_GnarSmall", "DA_Gromp18_AP", "DA_18_Hecarim", "DA_18_Ivern", "DA_Karma18",
    "DA_18_Kayle", "DA_18_Kennen", "DA_18_KhaZix", "DA_18_Kobuko", "DA_KogMaw18_AD", "DA_Krug18",
    "DA_18_LeBlanc", "DA_18_Leona", "DA_18_Lillia", "DA_18_Lux_Coven", "DA_18_Lux_Elderwood", "DA_18_Lux_Fae",
    "DA_18_Lux_Inferno", "DA_18_Lux_Moonbeam", "DA_18_Lux_Primal", "DA_18_Lux_Sunbeam", "DA_Lux18_Base", "DA_Lux18_Blackthorn",
    "DA_Lux18_Blossom", "DA_18_Malphite", "DA_CrimsonRaptor18", "DA_18_Maokai", "DA_18_MasterYi_AD", "DA_18_Morgana",
    "DA_Murkwolf18", "DA_Nidalee18_AP", "DA_18_Ornn", "DA_18_Sentry", "DA_18_Rakan", "DA_18_Rammus",
    "DA_18_RekSai", "DA_18_Rengar", "DA_Scuttlecrab18", "DA_18_Sejuani", "DA_Sentinel18", "DA_18_Sett",
    "DA_18_Shen", "DA_18_Sivir", "DA_18_Soraka", "DA_Taric18", "DA_18_Teemo", "DA_18_Tristana",
    "DA_18_Varus", "DA_18_Veigar", "DA_Vi18", "DA_18_Warwick", "DA_18_Xayah", "DA_18_Yorick",
    "DA_18_Yunara", "DA_18_Zyra"
  ),
  Champion = c(
    "Ahri", "Akali", "Alistar", "Alune", "Amumu", "Aphelios",
    "Ashe", "Azir", "Brambleback", "Caitlyn", "Camille", "Cassiopeia",
    "Cinderling", "Diana", "Draven", "Elder Dragon", "Elise", "Ezreal",
    "Fiddlesticks", "Gnar", "Gromp", "Hecarim", "Ivern", "Karma",
    "Kayle", "Kennen", "Kha'Zix", "Kobuko", "Kog'Maw", "Krug",
    "LeBlanc", "Leona", "Lillia", "Lux", "Lux", "Lux",
    "Lux", "Lux", "Lux", "Lux", "Lux", "Lux",
    "Lux", "Malphite", "Mama Beak", "Maokai", "Master Yi", "Morgana",
    "Murkwolf", "Nidalee", "Ornn", "Pebbles", "Rakan", "Rammus",
    "Rek'Sai", "Rengar", "Scuttlecrab", "Sejuani", "Sentinel", "Sett",
    "Shen", "Sivir", "Soraka", "Taric", "Teemo", "Tristana",
    "Varus", "Veigar", "Vi", "Warwick", "Xayah", "Yorick",
    "Yunara", "Zyra"
  ),
  trait1 = c(
    "Blossom", "Inferno", "Elderwood", "Attuned", "Inferno", "Lunar",
    "Blossom", "Blackthorn", "Riftbeast", "Coven", "Coven", "Coven",
    "Riftbeast", "Lunar", "Bounty Seeker", "Apex Predator", "Coven", "Elderwood",
    "Flora Fatalis", "Elderwood", "Riftbeast", "Elderwood", "Greenfather", "Blossom",
    "Solar", "Inferno", "Rival", "Sprykin", "Caustic", "Riftbeast",
    "Elderwood", "Solar", "Fae", "Coven", "Elderwood", "Fae",
    "Inferno", "Lunar", "Primal", "Solar", "Avatar", "Blackthorn",
    "Blossom", "Blackthorn", "Riftbeast", "Old Growth", "Blossom", "Coven",
    "Riftbeast", "Primal", "Elderwood", "Riftbeast", "Fae", "Sprykin",
    "Blackthorn", "Rival", "Riftbeast", "Solar", "Riftbeast", "Blossom",
    "Inferno", "Primal", "Flora Fatalis", "Emerald Aspect", "Sprykin", "Fae",
    "Inferno", "Blackthorn", "Primal", "Blackthorn", "Elderwood", "Blossom",
    "Blossom", "Thornmaiden"
  ),
  trait2 = c(
    "Spellweaver", "Adaptor", "Brawler", "Lunar", "Juggernaut", "Rapidfire",
    "Hunter", "Executioner", "Ravager", "Hunter", "Ravager", "Spellweaver",
    "Hunter", "Ravager", NA, "Riftbeast", "Vanguard", "Executioner",
    "Defender", "Sprykin", "Adaptor", "Vanguard", NA, "Spellweaver",
    "Rapidfire", "Executioner", NA, "Brawler", "Adaptor", "Brawler",
    "Spellweaver", "Defender", "Defender", "Avatar", "Avatar", "Avatar",
    "Avatar", "Avatar", "Avatar", "Avatar", NA, "Avatar",
    "Avatar", "Monolith", "Summoner", "Juggernaut", "Adaptor", "Invoker",
    "Ravager", "Adaptor", "Defender", "Invoker", "Juggernaut", "Defender",
    "Brawler", NA, "Juggernaut", "Juggernaut", "Vanguard", "Brawler",
    "Defender", "Hunter", "Executioner", "Vanguard", "Invoker", "Sprykin",
    "Rapidfire", "Sprykin", "Juggernaut", "Ravager", "Fae", "Juggernaut",
    "Executioner", "Summoner"
  ),
  trait3 = c(
    NA, "Ravager", NA, "Spellweaver", NA, NA,
    NA, "Summoner", NA, NA, NA, NA,
    NA, "Vanguard", NA, NA, NA, NA,
    "Spellweaver", "Brawler", NA, NA, NA, NA,
    NA, NA, NA, NA, "Invoker", NA,
    NA, NA, NA, NA, NA, NA,
    NA, NA, NA, NA, NA, NA,
    NA, NA, "Rapidfire", NA, NA, NA,
    NA, NA, NA, NA, "Vanguard", NA,
    NA, NA, NA, NA, "Invoker", NA,
    NA, NA, NA, NA, NA, "Hunter",
    NA, "Spellweaver", NA, NA, "Rapidfire", "Summoner",
    NA, NA
  ),
  stringsAsFactors = FALSE
)
