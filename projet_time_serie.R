# Installer et charger les packages nécessaires
#install.packages(c("tidyverse", "zoo", "tseries"))
library(tidyverse)
library(zoo)
library(tseries)
library(forecast)


# Charger les données
hour_data <-  read.csv("bike+sharing+dataset/hour.csv")
day_data <-  read.csv("bike+sharing+dataset/day.csv")

# Examiner les premières lignes des données
head(hour_data)
head(day_data)

# Examiner les dernieres lignes des données
tail(hour_data)
tail(day_data)


# Convertir les colonnes de date en classe Date
hour_data$dteday <- as.Date(hour_data$dteday)
day_data$dteday <- as.Date(day_data$dteday)

# Analyse des températures au fil des saisons
# Convertir la variable de saison en facteur pour l'ordre correct
hour_data$season <- factor(hour_data$season, levels = c(1, 2, 3, 4), labels = c("Spring", "Summer", "Fall", "Winter"))

# Créer le graphique de ligne
ggplot(hour_data, aes(x = dteday, y = temp, group = season, color = season)) +
  geom_line() +
  labs(title = "Évolution des températures par saison",
       x = "Date",
       y = "Température") +
  scale_color_manual(values = c("Spring" = "green", "Summer" = "yellow", "Fall" = "orange", "Winter" = "blue"))


# Grouper les données par saison
grouped_data <- hour_data %>%
  group_by(season)

# Calculer la moyenne et la médiane pour chaque saison
seasonal_summary <- summarise(grouped_data,
                              moyenne_temp = mean(temp),
                              mediane_temp = median(temp))

# Afficher les résultats
print(seasonal_summary)

# Convertir la température en Celsius
hour_data$celsius_temp <- hour_data$temp * (39 - (-8)) + (-8)

# Grouper les données par saison
grouped_data <- hour_data %>%
  group_by(season)

# Calculer la moyenne et la médiane pour chaque saison
seasonal_summary <- summarise(grouped_data,
                              moyenne_temp = mean(celsius_temp),
                              mediane_temp = median(celsius_temp))

# Afficher les résultats
print(seasonal_summary)

# Calculer la température moyenne
temperature_moyenne <- mean(hour_data$temp)

# Calculer la température médiane
temperature_mediane <- median(hour_data$temp)

# Afficher les résultats
cat("Température moyenne :", temperature_moyenne, "\n")
cat("Température médiane :", temperature_mediane, "\n")


# Température normalisée moyenne
temperature_norm_moyenne <- temperature_moyenne  

# Température normalisée médiane
temperature_norm_mediane <- temperature_mediane  

# Paramètres de normalisation
t_min <- -8
t_max <- 39

# Conversion de la température normalisée en Celsius
temperature_moyenne <- temperature_norm_moyenne * (t_max - t_min) + t_min
temperature_mediane <- temperature_norm_mediane * (t_max - t_min) + t_min

# Afficher les résultats
cat("Température moyenne en Celsius :", temperature_moyenne, "\n")
cat("Température médiane en Celsius :", temperature_mediane, "\n")



# Corrélation entre température et nombre total de locations
correlations <- cor(hour_data[c("temp", "atemp", "cnt")])
print(correlations)

# Agréger les données par mois
hour_data_monthly <- hour_data %>%
  group_by(year = lubridate::year(dteday), month = lubridate::month(dteday)) %>%
  summarise(mean_temp = mean(temp),
            mean_hum = mean(hum),
            mean_windspeed = mean(windspeed),
            mean_cnt = mean(cnt))

# Afficher les moyennes mensuelles
print(hour_data_monthly)

# Corrélation entre température et locations de vélos
correlation_registered <- cor(hour_data$casual, hour_data$temp)
correlation_casual <- cor(hour_data$registered, hour_data$temp)

# Afficher les corrélations
print(paste("Corrélation avec utilisateurs enregistrés:", correlation_registered))
print(paste("Corrélation avec utilisateurs occasionnels:", correlation_casual))

# Tracer le cnt en fonction du jour
plot(day_data$dteday, day_data$cnt, type = "l", col = "blue", xlab = "Date", ylab = "Nombre total de locations")

# Nettoyer les valeurs aberrantes ou manquantes si nécessaire
# ...

# Convertir les données en série temporelle avec la bonne fréquence
day_datatimeseries <- ts(day_data$cnt, frequency = 30)

# Tracer la série temporelle originale
plot(day_datatimeseries, main = "Nombre de vélos partagés par mois", xlab = "mois", ylab = "Nombre de vélos partagés", col = "blue")

# Appliquer une moyenne mobile (lissage)
window_size <- 7
ts_smooth <- stats::filter(day_datatimeseries, rep(1/window_size, window_size), sides = 2)

# Tracer la série lissée
lines(ts_smooth, col = "red")

# Supprimer les valeurs manquantes
ts_smooth <- na.omit(ts_smooth)

# Test de stationnarité (exemple avec ADF test)
adf_test <- adf.test(ts_smooth)
print(adf_test)

# Vérifier l'ACF et le PACF de la série temporelle lissée
acf(ts_smooth)
pacf(ts_smooth)
# Calculer et tracer l'ACF
acf_result <- acf(ts_smooth, main = "ACF de la série temporelle lissée")
# Calculer et tracer le PACF
pacf_result <- pacf(ts_smooth, main = "PACF de la série temporelle lissée")


# Exemple pour ARIMA(1, 0, 0)
model_arima <- arima(ts_smooth, order = c(1, 0, 0))


summary(model_arima)


# Supprimer la saison de cnt
#Décomposition saisonnière
decomposition <- decompose(ts_smooth)
plot(decomposition)
seasonal <- decomposition$seasonal
plot(seasonal, main = "seasonal")
seasonal_difference2 = ts_smooth-decomposition$seasonal
plot(seasonal_difference2, col = "blue", xlab = "Mois", ylab = "Nombre total de locations")

# Vérifier l'ACF et le PACF de la série temporelle différenciée
acf(seasonal_difference2)
pacf(seasonal_difference2)


model_arima_diff <- arima(seasonal_difference, order = c(1, 1, 1)) 

# Afficher un résumé du modèle
summary(model_arima_diff)

# Ajuster un modèle ARIMA automatique
auto_model <- auto.arima(seasonal_difference2)


# Vérifier les résidus du modèle
checkresiduals(auto_model)

# Réajuster le modèle si nécessaire

# Calculer les prévisions à l'aide du modèle choisi
forecast_values <- forecast(auto_model, h = 25)

# Tracer à la fois la série temporelle originale et la série temporelle prévue
plot(ts_smooth)
lines(forecast_values$mean, col = "red")

# IV. Prévisions :
# Diviser les données en séries temporelles d'entraînement et de test
train_data <- ts_smooth[1:700]
test_data <- ts_smooth[701:length(ts_smooth)]

# Ajuster un modèle ARIMA manuellement sur la partie d'entraînement
manual_model <- Arima(train_data, order = c(1, 0, 1))


# Prévoir les 25 prochaines observations avec le modèle ajusté manuellement
forecast_manual <- forecast(manual_model, h = 25)


# Tracer le ts original et le ts prévu avec le modèle ajusté manuellement
plot(forecast_manual)
plot(forecast_values)

