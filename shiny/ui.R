# shiny/ui.R
library(shiny)
library(bslib)
library(fontawesome)   # so you can say fa("chart-column") etc.

# ---------- 1. Global theme ----------
moses_theme <- bs_theme(
  bootswatch = "flatly",
  primary    = "#1e3a8a",     # blue
  secondary  = "#0d9488",     # teal
  base_font  = font_google("Poppins")
)

# ---------- 2. Top NAVBAR ----------
top_nav <- page_navbar(
  title = tags$span("MOSES", style = "font-weight:600;"),
  id    = "topnav",
  nav_item(a("Home",   href = "../index.html", target = "_blank")),
  nav_item(a("About",  href = "../about.html", target = "_blank")),
  nav_item(a("Tutorials",  href = "../tutorials.html", target = "_blank")),
  nav_spacer(),
  nav_item(a("Methodology", href = "../methodology.html", target = "_blank"))
)

# ---------- 3. Secondary NAVSET (horizontal pills) ----------
secondary_nav <- navset_bar(
  id = "secondary",
  nav_panel("Clean",     value = "clean"),
  nav_panel("Taxonomy",  value = "taxonomy"),
  nav_panel("Ordinations", value = "ordinate"),
  nav_panel("Clustering",  value = "cluster"),
  nav_panel("Statistics",  value = "stats"),
  nav_panel("BFI",         value = "bfi")
)

# ---------- 4. Layout with collapsible sidebar ----------
ui <- page_fillable(
  theme  = moses_theme,
  padding = 0,
  top_nav,
  
  # secondary bar just below primary
  secondary_nav,
  
  # L-sidebar + main frame (auto-collapsible on <992 px)
  layout_sidebar(
    sidebar = sidebar(
      title = "Advanced",
      fa("sliders"), "   Toggle tools",
      hr(),
      # ↓ auto-generated from manifest
      uiOutput("adv_sidebar")
    ),
    # ↓ dynamic panel for whichever module is active
    uiOutput("main_panel")
  )
)
