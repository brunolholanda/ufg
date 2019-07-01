library(neuralnet)

## http://archive.ics.uci.edu/ml/datasets.php
## Concrete Compressive Strength

concrete <- read.csv("/home/bruno/Área de Trabalho/kNN/concrete.csv")


normalize <- function(x) {
  return((x - min(x)) / (max(x) - min(x)))
}

concrete_norm <- as.data.frame(lapply(concrete, normalize))

summary(concrete_norm$strength)
summary(concrete$strength)

concrete_train <- concrete_norm[1:773, ]
concrete_test <- concrete_norm[774:1030, ]

concrete_model <- neuralnet(strength ~ cement + slag +
                              ash + water + superplastic +
                              coarseagg + fineagg + age,
                            data = concrete_train)

plot(concrete_model)

model_results <- compute(concrete_model, concrete_test[1:8])

predicted_strength <- model_results$net.result

cor(predicted_strength, concrete_test$strength)

#########################
concrete_model2 <- neuralnet(strength ~ cement + slag +
                               ash + water + superplastic +
                               coarseagg + fineagg + age,
                             data = concrete_train, hidden = 5)

