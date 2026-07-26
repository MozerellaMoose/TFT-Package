
.Fancy_Output <- function(lines) {
  width <- max(nchar(lines)) + 5
  top <- paste0("╭", paste(rep("─", width), collapse=""), "╮")
  bot <- paste0("╰", paste(rep("─", width), collapse=""), "╯")
  
  cat(top, "\n")
  for (l in lines) {
    cat(sprintf("│ %-*s │\n", width -2, l))
  }
  cat(bot, "\n")
}
