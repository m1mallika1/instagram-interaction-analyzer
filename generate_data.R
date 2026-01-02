library(tidyverse)
library(lubridate)


usernames <- c(
  "michrussan", "dncs.am", "meryem_sinrs_19", "saisai_ss1", "user012446",
  "fr_e_yhh", "miadu07", "hus.na032", "thetmon1615", "zya_niazik", "km._.bp_e",
  "uerrrr335566", ".ilv.rly", "4uraie1610", "krisnaimeotscc", "kristineimoetscc",
  "athena_marise", "hoain_majib", "gb4vndm", "patriciamaria3411", "ashleymacarilay",
  "c_syd", "ish.aa355", "_yehaniexevr", "warayanu", "wulanya_06", "mcquinn_",
  "baij_by", "imstartcen262100", "imoeshey", "hihibyebye_1255", "anindyayayy____",
  "nopydd", "userr_picauwww", "hxneytsm", "manfah_124", "rasti9198", "wukum_1",
  "laknoo.1", "wao.07", "michell_cherlyn23", "chenmenghan515", "m.lymxh",
  "n0t_kyy1", "delia_rose27", "qqqa_syaysa", "lima_s_ana_", "qqqq_syaysa",
  "lima_s_sna", "nnqsya_", "_ra8sha_"
)

set.seed(42)  # For reproducibility

# Generate mock dataset
df <- tibble(
  post_id = 1:100,
  timestamp = seq(Sys.Date() - 99, Sys.Date(), by = "day"),
  post_type = sample(c("Image", "Video", "Reel"), 100, replace = TRUE),
  likes = sample(50:500, 100, replace = TRUE),
  comments = sample(10:100, 100, replace = TRUE),
  saves = sample(5:50, 100, replace = TRUE),
  user_id = sample(usernames, 100, replace = TRUE),
  comment_text = sample(
    c("Love this!", "Amazing!", "So cool!", "Nice post!", "🔥"),
    100, replace = TRUE
  )
) %>%
  mutate(
    engagement_score = likes + comments + saves,
    weekday = wday(timestamp, label = TRUE),
    hour = sample(0:23, n(), replace = TRUE)
  )

#  Save to CSV
write_csv(df, "C:/Users/dell/Desktop/InstaAnalyz/data/instagram_data.csv")