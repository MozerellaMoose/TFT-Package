# TFT Set 17 Space Gods champion/trait look-up table

.Trait_Table_Set17 <- data.frame(
  units_character_id = c(
    "TFT17_Aatrox", "TFT17_Akali", "TFT17_AurelionSol", "TFT17_Aurora", "TFT17_Bard", "TFT17_Belveth",
    "TFT17_Blitzcrank", "TFT17_Briar", "TFT17_Caitlyn", "TFT17_Chogath", "TFT17_Corki", "TFT17_Diana",
    "TFT17_Ezreal", "TFT17_Fiora", "TFT17_Fizz", "TFT17_Gnar", "TFT17_Gragas", "TFT17_Graves",
    "TFT17_Gwen", "TFT17_Illaoi", "TFT17_Jax", "TFT17_Jhin", "TFT17_Jinx", "TFT17_Kaisa",
    "TFT17_Karma", "TFT17_Kindred", "TFT17_Leblanc", "TFT17_Leona", "TFT17_Lissandra", "TFT17_Lulu",
    "TFT17_Maokai", "TFT17_MasterYi", "TFT17_IvernMinion", "TFT17_Milio", "TFT17_MissFortune", "TFT17_Mordekaiser",
    "TFT17_Morgana", "TFT17_Nami", "TFT17_Nasus", "TFT17_Nunu", "TFT17_Ornn", "TFT17_Pantheon",
    "TFT17_Poppy", "TFT17_Pyke", "TFT17_Rammus", "TFT17_RekSai", "TFT17_Rhaast", "TFT17_Riven",
    "TFT17_Samira", "TFT17_Shen", "TFT17_Sona", "TFT17_TahmKench", "TFT17_Talon", "TFT17_Teemo",
    "TFT17_Galio", "TFT17_TwistedFate", "TFT17_Urgot", "TFT17_Veigar", "TFT17_Vex", "TFT17_Viktor",
    "TFT17_Xayah", "TFT17_Zed", "TFT17_Zoe"
  ),
  Champion = c(
    "Aatrox", "Akali", "Aurelion Sol", "Aurora", "Bard", "Bel'Veth",
    "Blitzcrank", "Briar", "Caitlyn", "Cho'Gath", "Corki", "Diana",
    "Ezreal", "Fiora", "Fizz", "Gnar", "Gragas", "Graves",
    "Gwen", "Illaoi", "Jax", "Jhin", "Jinx", "Kai'Sa",
    "Karma", "Kindred", "LeBlanc", "Leona", "Lissandra", "Lulu",
    "Maokai", "Master Yi", "Meepsie", "Milio", "Miss Fortune", "Mordekaiser",
    "Morgana", "Nami", "Nasus", "Nunu & Willump", "Ornn", "Pantheon",
    "Poppy", "Pyke", "Rammus", "Rek'Sai", "Rhaast", "Riven",
    "Samira", "Shen", "Sona", "Tahm Kench", "Talon", "Teemo",
    "The Mighty Mech", "Twisted Fate", "Urgot", "Veigar", "Vex", "Viktor",
    "Xayah", "Zed", "Zoe"
  ),
  trait1 = c(
    "N.O.V.A.", "N.O.V.A.", "Mecha", "Anima", "Meeple", "Primordian",
    "Party Animal", "Anima", "N.O.V.A.", "Dark Star", "Meeple", "Arbiter",
    "Timebreaker", "Divine Duelist", "Meeple", "Meeple", "Psionic", "Factory New",
    "Space Groove", "Anima", "Stargazer", "Dark Star", "Anima", "Dark Star",
    "Dark Star", "N.O.V.A.", "Arbiter", "Arbiter", "Dark Star", "Stargazer",
    "N.O.V.A.", "Psionic", "Meeple", "Timebreaker", "Gun Goddess", "Dark Star",
    "Dark Lady", "Space Groove", "Space Groove", "Stargazer", "Space Groove", "Timebreaker",
    "Meeple", "Psionic", "Meeple", "Primordian", "Redeemer", "Timebreaker",
    "Space Groove", "Bulwark", "Commander", "Oracle", "Stargazer", "Space Groove",
    "Mecha", "Stargazer", "Mecha", "Meeple", "Doomer", "Psionic",
    "Stargazer", "Galaxy Hunter", "Arbiter"
  ),
  trait2 = c(
    "Bastion", "Marauder", "Conduit", "Voyager", "Conduit", "Challenger",
    "Space Groove", "Primordian", "Fateweaver", "Brawler", "Fateweaver", "Challenger",
    "Sniper", "Anima", "Rogue", "Sniper", "Brawler", NA,
    "Rogue", "Vanguard", "Bastion", "Eradicator", "Challenger", "Rogue",
    "Voyager", "Challenger", "Shepherd", "Vanguard", "Shepherd", "Replicator",
    "Brawler", "Marauder", "Shepherd", "Fateweaver", "Choose Trait", "Conduit",
    NA, "Replicator", "Vanguard", "Vanguard", "Bastion", "Brawler",
    "Bastion", "Voyager", "Bastion", "Brawler", NA, "Rogue",
    "Sniper", "Timebreaker", "Psionic", "Brawler", "Rogue", "Shepherd",
    "Voyager", "Fateweaver", "Brawler", "Replicator", "Stargazer", "Conduit",
    "Sniper", NA, "Conduit"
  ),
  trait3 = c(
    NA, NA, NA, NA, NA, "Marauder",
    "Vanguard", "Rogue", NA, NA, NA, NA,
    NA, "Marauder", NA, NA, NA, NA,
    NA, "Shepherd", NA, "Sniper", NA, NA,
    NA, NA, NA, NA, "Replicator", NA,
    NA, NA, "Voyager", NA, NA, "Vanguard",
    NA, NA, NA, NA, NA, "Replicator",
    NA, NA, NA, NA, NA, NA,
    NA, "Bastion", "Shepherd", NA, NA, NA,
    NA, NA, "Marauder", NA, NA, NA,
    NA, NA, NA
  ),
  stringsAsFactors = FALSE
)
