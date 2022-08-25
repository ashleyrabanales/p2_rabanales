
library(tidyverse)
library(waffle)
library(ggfittext)

httpgd::hgd()
httpgd::hgd_browse()

storms %>% 
  filter(year >= 2010) %>% 
  count(year, status) -> storms_df

ggplot(storms_df, aes(fill = status, values = n)) +
  geom_waffle(color = "white", size = .25, n_rows = 10, flip = TRUE) +
  facet_wrap(~year, nrow = 1, strip.position = "bottom") +
  scale_x_discrete() + 
  scale_y_continuous(labels = function(x) x * 10, # make this multiplyer the same as n_rows
                     expand = c(0,0)) +
  ggthemes::scale_fill_tableau(name=NULL) +
  coord_equal() +
  labs(
    title = "Faceted Waffle Bar Chart",
    subtitle = "{dplyr} storms data",
    x = "Year",
    y = "Count"
  ) +
  theme_minimal(base_family = "Roboto Condensed") +
  theme(panel.grid = element_blank(), axis.ticks.y = element_line()) +
  guides(fill = guide_legend(reverse = TRUE))

#example with heatmap

storms %>% 
  filter(year >= 2010) %>% 
  count(year, status) -> storms_df_all

storms_df_all %>%
  ggplot(aes( x = years, y = status, fill = n)) +
  geom_tile () +
  geom_fit_text(size = 4, ))
  scale_fill_viridis_c() +
  coord_fixed()

#better labels
#color change
#theme 
## 
