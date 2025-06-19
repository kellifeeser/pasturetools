# ---------------------------------------------------------------------
# server.R  –  MOSES Data-Explorer runtime
# ---------------------------------------------------------------------
#  ✱  Loads analysis modules from R/modules
#  ✱  Manages app-level state (dataset loaded?, which module?, etc.)
#  ✱  Delegates UI + server work to per-module functions
# ---------------------------------------------------------------------

library(shiny)
library(tibble)
library(purrr)
library(fontawesome)  # for nice sidebar icons
library(readr)        # example loader – swap with pastureTools later

# ─────────────────────────────────────────────────────────────────────
# 1.  SOURCE ALL MODULE FILES
#     Each file must define <key>_ui()  *and*  <key>_srv()
# ─────────────────────────────────────────────────────────────────────
module_files <- list.files(
  "R/modules", pattern = "\\.R$", recursive = TRUE, full.names = TRUE
)
walk(module_files, source)

# grab any objects ending _ui / _srv that are *functions*
all_ui_fns  <- Filter(is.function, mget(ls(pattern = "_ui$"),  .GlobalEnv))
all_srv_fns <- Filter(is.function, mget(ls(pattern = "_srv$"), .GlobalEnv))

strip_suffix <- function(vec) sub("_(ui|srv)$", "", vec)

module_ui_map <- setNames(all_ui_fns,  strip_suffix(names(all_ui_fns)))
module_srv_map <- setNames(all_srv_fns, strip_suffix(names(all_srv_fns)))

# ─────────────────────────────────────────────────────────────────────
# 2.  SIDEBAR MANIFEST (easy to extend)
# ─────────────────────────────────────────────────────────────────────
manifest <- tribble(
  ~key,        ~title,              ~icon,             ~needs_data,
  "cooccur",   "Co-occurrence",     "sitemap",         TRUE,
  "network",   "Network Centrality","diagram-project", TRUE,
  "ml",        "Meta-learning",     "brain",           TRUE
)

# ─────────────────────────────────────────────────────────────────────
# 3.  SERVER FUNCTION
# ─────────────────────────────────────────────────────────────────────
server <- function(input, output, session) {
  # ---------- 3a. Reactives for global state ----------
  vals <- reactiveValues(
    data_loaded = FALSE,
    current_app = "home",
    tractor     = NULL         # will hold your imported TRACTOR object
  )
  
  # keep top-bar & sidebar selections in sync
  observeEvent(input$secondary, {
    vals$current_app <- input$secondary
  }, ignoreInit = TRUE)
  
  # ---------- 3b. DATA LOADING (placeholder) ----------
  observeEvent(input$load_demo, {           # <- add this button later
    showNotification("Loading demo dataset…", type = "message")
    Sys.sleep(1)                            # fake delay
    vals$tractor     <- readRDS("demo/demo_tractor.rds")
    vals$data_loaded <- TRUE
    showNotification("Demo dataset loaded!", type = "default")
  })
  
  # ---------- 3c. ADVANCED SIDEBAR UI ----------
  output$adv_sidebar <- renderUI({
    tagList(
      lapply(seq_len(nrow(manifest)), function(i) {
        row  <- manifest[i, ]
        disabled <- row$needs_data && !vals$data_loaded
        actionLink(
          inputId = row$key,
          label   = tagList(fa(row$icon), row$title),
          class   = if (disabled) "disabled link-secondary" else NULL,
          style   = "margin: .25rem 0; display:block;"
        )
      })
    )
  })
  
  # ---------- 3d. ADVANCED SIDEBAR CLICK HANDLERS ----------
  lapply(manifest$key, function(k) {
    observeEvent(input[[k]], {
      vals$current_app <- k
      updateNavs(session, "secondary", selected = character(0)) # unselect pills
    }, ignoreInit = TRUE)
  })
  
  # ---------- 3e. MAIN-PANEL UI DISPATCH ----------
  output$main_panel <- renderUI({
    app <- vals$current_app
    
    # 1) Home (welcome screen)
    if (app == "home") {
      return(
        div(
          style = "padding:2rem;",
          h2("Welcome to the MOSES Data Explorer"),
          p("Load a dataset to unlock the full toolkit."),
          actionButton("load_demo", "Load Demo Data", class = "btn btn-success")
        )
      )
    }
    
    # 2) If we have a UI function for this key, call it
    if (app %in% names(module_ui_map)) {
      return(module_ui_map[[app]](app))
    }
    
    div("Module not found 🤔")
  })
  
  # ---------- 3f. PER-MODULE SERVER DISPATCH ----------
  observe({
    app <- vals$current_app
    req(app %in% names(module_srv_map))
    
    module_srv_map[[app]](
      id      = app,
      tractor = reactive(vals$tractor)   # pass as reactive for live updates
    )
  })
}
