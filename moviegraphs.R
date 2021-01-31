library(tidyverse)


movies <- read.csv(file = "movies.csv")
movies <- movies %>% select(-Type, -X) %>%
  mutate(Country = as.character(Country)) %>% 
  mutate(Country= strsplit(Country, split=",")) %>%
  mutate(`Rotten Tomatoes`= gsub("%","",`Rotten Tomatoes`)) %>%
  mutate(`Rotten Tomatoes`= as.numeric(`Rotten Tomatoes`))

class(movies$Country)

N <- movies %>% filter(Netflix=='1')

# Movie count by years
movies %>% group_by(Year) %>% 
  summarise(Netflix= sum(Netflix == "1"),
            Hulu= sum(Hulu == "1"),
            Prime=sum(`Prime Video` == "1"),
            Disney=sum(`Disney +` =="1")) %>% 
              gather( "Streaming Service", "Count", -Year) %>% ggplot(aes(Year, Count)) + 
              geom_col(aes(fill = `Streaming Service`), position = "dodge") + facet_wrap(~`Streaming Service`)

# Rotten Tomatoes average

RT<- movies %>% select(Netflix, Hulu, `Prime Video`, `Disney+`, `Rotten Tomatoes`)
RT <- RT %>% summarise(Netflix= ifelse(Netflix=='1',`Rotten Tomatoes`,NA),
                    Hulu= ifelse(Hulu=='1',`Rotten Tomatoes`,NA),
                    `Prime Video`= ifelse(`Prime Video`=='1',`Rotten Tomatoes`,NA),
                    `Disney+`= ifelse(`Disney+`=='1',`Rotten Tomatoes`,NA)) %>%
  as.data.table(RT)
m <- melt.data.table(RT) %>% rename(`Streaming Service`= variable,
                                    `Rotten Tomatoes Score`= value)
m %>% ggplot(aes(x=`Rotten Tomatoes Score`, color=`Streaming Service`)) + 
  geom_density(alpha = 0.2) 
  



#movie count
movies %>% summarise(Netflix= sum(Netflix == "1"),
            Hulu= sum(Hulu == "1"),
            Prime=sum(`Prime Video` == "1"),
            Disney=sum(`Disney+`=="1")) %>% gather( "Streaming Service", "Count") %>% ggplot(aes(`Streaming Service`, Count)) + 
  geom_bar(stat='identity', position = "dodge")

#netflix age distribution
N %>% filter(!(Age==""))%>%
  mutate(Age = fct_relevel(Age, 
                           "18+", "16+", "13+", 
                           "7+", "all")) %>% group_by(Age)%>%
  summarise(n=n()) %>% ggplot(aes(x="", y=n, fill=Age)) + geom_bar(stat='identity') + coord_polar("y", start=0) +
  theme_void()+  ggtitle('Netflix Age Distribution')


#Country map
binary <- lapply(movies$Country, function(x) {
  vals <- unique(x) 
  x <- setNames(rep(1,length(vals)), vals);
  do.call(data.frame, as.list(x))
})
result <- do.call(plyr::rbind.fill, binary)
names(result) <- gsub(".", " ", names(result), fixed = TRUE)


countrymovies <- movies %>% full_join(result)
countrymovies <- as.data.frame(countrymovies)
names(countrymovies) <- gsub(".", " ", names(countrymovies), fixed = TRUE)
class(countrymovies)

library(data.table)
result<- as.data.table(result)
result <- melt.data.table(result) 
result

countrymovies %>% filter(`United States`=='1') %>% 
  summarise(N=sum(Netflix=='1'),
            H=sum(Hulu=='1'),
            P=sum(Prime.Video=='1'),
            D=sum(Disney.=='1'))




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
genremovies <- as.data.frame(genremovies)


genremovies %>% filter(Action=='1') %>% 
  summarise(N=sum(Netflix=='1'),
            H=sum(Hulu=='1'),
            P=sum(`Prime Video`=='1'),
            D=sum(`Disney+`=='1'))  %>% gather( "Streaming Service", "Count") %>% 
  ggplot(aes(`Streaming Service`, Count)) + 
  geom_bar(stat='identity', position = "dodge")





