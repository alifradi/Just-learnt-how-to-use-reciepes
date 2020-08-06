library(AmesHousing)
library(recipes)
library(rsample)
# collect data
ames <- make_ames()
# split to train / test sets
set.seed(4595)
data_split <- initial_split(data = ames, prop = 3/4)
ames_train <- training(data_split)
ames_test <- testing(data_split)

# Define operations to process on data 

rec <- recipe(Sale_Price ~ Alley + Lot_Area, data = ames_train %>% head()) %>%
  step_log(Sale_Price) %>%
  step_dummy(Alley)

# Train the processing on part of data so we can reproduce it to other datasets
rec_trained <- prep(rec, training = ames_train, retain = TRUE)
# Get the outcamoing dataframe from rec_trained object
design_mat <-  juice(rec_trained)
# Apply the same transformations on the ames_test dataset
rec_test <- bake(rec_trained, new_data = ames_test)
