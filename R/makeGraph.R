library(tidyverse)
require(lubridate)
options(bitmapType='cairo')

data.org <- read_tsv('latest_weather.csv',col_names = F,progress = T)

colnames <- c('dt','name','metric','hourkey','date_time','value')

data <- data.org
colnames(data) <- colnames

data <- data %>% mutate(dt = as.Date(dt), date_time = ymd_hms(date_time))

metricnames <- read_csv('metric.csv')

metricnames <- metricnames %>% mutate(name = tolower(name), title = paste(description, '\n in ', unit, sep = ''))

hourkey_period <- read_csv('hourkey_period.csv')

data <- merge(data,metricnames, by.x = 'metric', by.y = 'name')
data <- merge(data,hourkey_period, by='hourkey')

data$period <- factor(data$period, levels = c("0-5","6-11","12-17","18-23"))

data <- data %>% filter(type != 'string' & metric != 'w') %>% mutate(value = as.numeric(value)) %>% arrange(date_time)

file <- paste('benson.png', sep = '')
gp <- ggplot(data, aes(x=date_time, y = value)) + geom_point(aes(colour = period)) + 
  ggtitle(paste("Observations for Odiham ending ", max(data$date_time), sep = '')) + 
  theme_bw(base_size = 15) +  theme(axis.text.x=element_text(angle=60, hjust=1)) + 
  geom_line() + facet_grid(rows = vars(title), scales = 'free',)

ggsave(file, gp, width = 12, height = 9)
