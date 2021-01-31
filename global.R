
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

binary <- lapply(movies$Country, function(x) {
  vals <- unique(x) 
  x <- setNames(rep(1,length(vals)), vals);
  do.call(data.frame, as.list(x))
})
result <- do.call(plyr::rbind.fill, binary)
names(result) <- gsub(".", " ", names(result), fixed = TRUE)
result <- tibble::rowid_to_column(result, "ID")


countrymovies <- movies %>% full_join(result)

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


# select variables
choice <- colnames(movies[7:10])
countries <- colnames(countrymovies[16:183])
genre <- colnames(genremovies[16:42])
