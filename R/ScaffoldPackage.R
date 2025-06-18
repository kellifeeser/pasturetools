# Scaffold pastureTools package

# run this *once* in a clean directory
library(usethis)
usethis::use_git()
# usethis::use_mit_license("Kelli Feeser")
usethis::use_readme_rmd()
usethis::use_news_md()
usethis::use_tidy_description()


# declare pure-R deps that are already WASM-friendly
usethis::use_package("stats")      # base, but lists intent
usethis::use_package("vegan")      # ordinations, distances
usethis::use_package("dplyr")      # convenience
# usethis::use_package("tidyr")      # convenience
# usethis::use_package("tibble")     # tidy outputs
# usethis::use_package("stringr")    # misc helpers