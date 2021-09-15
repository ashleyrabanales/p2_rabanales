# Project 2: Reducing Gun Deaths (FiveThirtyEight) 

## Background 

The world is a dangerous place.  During 2015 and 2016, there was a lot of discussion in the [news about police shootings](http://www.cbsnews.com/pictures/controversial-police-shootings/).  [FiveThirtyEight](https://fivethirtyeight.com/) reported on [gun deaths in 2016](https://fivethirtyeight.com/features/gun-deaths/).  As leaders in data journalism, they have posted a clean version of this data in their Github repo called [full_data.csv](https://github.com/fivethirtyeight/guns-data) for us to use. 

The FiveThirtyEight data is a bit old, and our client would like us to use the [most recent data from the CDC](https://www.cdc.gov/nchs/data_access/VitalStatsOnline.htm#Mortality_Multiple).  He would also like the [parser script to use Python instead of R](https://github.com/fivethirtyeight/guns-data/blob/master/CDC_parser.R
).

While their visualizations focused on yearly averages, our client wants to create commercials that help reduce gun deaths in the US.  They would like to target the commercials in different seasons of the year (think month variable) to audiences that could significantly reduce gun deaths. Our challenge is to summarize and visualize seasonal trends across the other variables in these data.

## Reading

- [R4DS: Chapter 5 Data transformation](https://r4ds.had.co.nz/transform.html)
- [R4DS: Chapter 7 Exploratory Data Analysis](https://r4ds.had.co.nz/exploratory-data-analysis.html)
- [Py4DS: Chapter 5 Data transformation](https://byuidatascience.github.io/python4ds/transform.html)
- [Py4DS: Chapter 7 Exploratory Data Analysis](https://byuidatascience.github.io/python4ds/exploratory-data-analysis.html)

## Tasks

### Python translation

- [ ] Translate [FiveThirtyEight's CDC_parser.R script](https://github.com/fivethirtyeight/guns-data/blob/master/CDC_parser.R) into a Python script.
- [ ] Verify that your output matches their results.
- [ ] Build new data sets that use data through 2019.

### Client needs (charts and munging done in Python and R)

- [ ] Provide a brief summary of the [FiveThirtyEight article](https://fivethirtyeight.com/features/gun-deaths/).
    - [ ] Create one plot that provides similar insight to their visualization in the article. It does not have to look like theirs.
    - [ ] Write a short paragraph summarizing their article.
- [ ] Address the client's need for emphasis areas of their commercials for different seasons of the year.
    - [ ] Provide plots that help them know the different potential groups (variables) they could address in different seasons (2-4 visualizations seem necessary).
    - [ ] Write a short paragraph describing each image.



