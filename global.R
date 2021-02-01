library(dplyr)
library(data.table)
movies <- read.csv(file = "movies.csv")
movies <- movies %>% select(-Type, -X) %>%
rename(`Disney+`=Disney.,
         `Prime Video`=Prime.Video,
         `Rotten Tomatoes`=Rotten.Tomatoes) %>%
  mutate(Country = as.character(Country)) %>% 
  mutate(Country= strsplit(Country, split=",")) %>%
  mutate(`Rotten Tomatoes`= gsub("%","",`Rotten Tomatoes`)) %>%
  mutate(`Rotten Tomatoes`= as.numeric(`Rotten Tomatoes`)) %>%
  mutate(Age = fct_relevel(Age, 
                           "18+", "16+", "13+", 
                           "7+", "all"))

# Country Map
binary <- lapply(movies$Country, function(x) {
  vals <- unique(x) 
  x <- setNames(rep(1,length(vals)), vals);
  do.call(data.frame, as.list(x))
})
result <- do.call(plyr::rbind.fill, binary)
names(result) <- gsub(".", " ", names(result), fixed = TRUE)
result <- tibble::rowid_to_column(result, "ID")

countrymovies <- movies %>% full_join(result)

cc <- countrymovies %>% select(-ID,-Title,-Year,-Age,-IMDb,
                               -`Rotten Tomatoes`,-Directors,
                               -Genres,-Country, -Language, -Runtime) %>%
  gather(country, value, -Netflix,-Hulu,-`Prime Video`,-`Disney+`) %>%
  filter(value == '1') %>%
  select(-value) %>% group_by(country) %>% 
  summarise(Netflix=sum(Netflix=='1'),
            Hulu=sum(Hulu=='1'),
            `Prime Video`=sum(`Prime Video`=='1'),
            `Disney+`=sum(`Disney+`=='1'))

#Rotten Tomatoes Score - Density Plot
RT<- movies %>% select(Netflix, Hulu, `Prime Video`, `Disney+`, `Rotten Tomatoes`)
RT <- RT %>% summarise(Netflix= ifelse(Netflix=='1',`Rotten Tomatoes`,NA),
                       Hulu= ifelse(Hulu=='1',`Rotten Tomatoes`,NA),
                       `Prime Video`= ifelse(`Prime Video`=='1',`Rotten Tomatoes`,NA),
                       `Disney+`= ifelse(`Disney+`=='1',`Rotten Tomatoes`,NA)) %>%
  as.data.table(RT)
m <- melt.data.table(RT) %>% rename(`Streaming Service`= variable,
                                    `Rotten Tomatoes Score`= value)
#Imdb Score - Density Plot
IMDB_<- movies %>% select(Netflix, Hulu, `Prime Video`, `Disney+`, IMDb)
IMDB_ <- IMDB_ %>% summarise(Netflix= ifelse(Netflix=='1',IMDb,NA),
                       Hulu= ifelse(Hulu=='1',IMDb,NA),
                       `Prime Video`= ifelse(`Prime Video`=='1',IMDb,NA),
                       `Disney+`= ifelse(`Disney+`=='1',IMDb,NA)) %>%
  as.data.table(IMDB_)
IMDB_ <- melt.data.table(IMDB_) %>% rename(`Streaming Service`= variable,
                                    `IMDb Score`= value)

#Genre Data
movies<- movies %>% mutate(Genres = as.character(Genres)) %>% 
  mutate(Genres= strsplit(Genres, split=","))

binary <- lapply(movies$Genres, function(x) {
  vals <- unique(x) 
  x <- setNames(rep(1,length(vals)), vals);
  do.call(data.frame, as.list(x))
})
genres_result <- do.call(plyr::rbind.fill, binary)
names(genres_result) <- gsub(".", " ", names(genres_result), fixed = TRUE)
genres_result <- tibble::rowid_to_column(genres_result, "ID")
genremovies <- movies %>% full_join(genres_result)

totals <- genremovies %>% 
  summarise(Netflix = sum(Netflix=='1'),
            Hulu=sum(Hulu=='1'),
            `Prime Video` = sum(`Prime Video`=='1'),
            `Disney+` =sum(`Disney+`=='1')) %>%
  gather('Streaming Service', 'Total')

# select variables
choice <- colnames(movies[7:10])
countries <- colnames(cc[2:5])
genre <- colnames(genremovies[16:42])
