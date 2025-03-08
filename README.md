# Projet d'Analyse de Séries Temporelles : Vélo en Libre-Service

Ce projet vise à analyser des données de vélos en libre-service et à appliquer des modèles de séries temporelles pour comprendre les tendances et effectuer des prévisions.

## Contenu du Projet

Le projet est composé des éléments suivants :
- Un rapport détaillé en PDF
- Un script R (`projet_time_serie.R`) contenant l'ensemble du code d'analyse
- le jeu de données "Bike Sharing Dataset"

## Données

L'analyse est donc basée sur le jeu de données "Bike Sharing Dataset" qui comprend :
- Un fichier de données horaires (`hour.csv`)
- Un fichier de données journalières (`day.csv`)

Ces données contiennent des informations sur :
- Le nombre de locations de vélos (total, utilisateurs enregistrés, utilisateurs occasionnels)
- Les conditions météorologiques (température, humidité, vitesse du vent)
- Des variables temporelles (saison, jour, mois, année)

## Méthodologie

L'analyse est structurée selon les étapes suivantes :

### 1. Exploration des Données
- Analyse des températures par saison
- Calcul des statistiques descriptives
- Étude des corrélations entre variables

### 2. Analyse de Séries Temporelles
- Création d'une série temporelle du nombre total de locations
- Lissage de la série par moyenne mobile
- Application d'une décomposition saisonnière
- Tests de stationnarité

### 3. Modélisation ARIMA
- Analyse des graphiques ACF et PACF
- Ajustement de différents modèles ARIMA
   - Modèle ARIMA(1,0,0)
   - Modèle ARIMA(1,1,1) sur la série désaisonnalisée
   - Modèle Auto-ARIMA

### 4. Prévisions
- Séparation des données en ensembles d'entraînement et de test
- Comparaison des prévisions issues des modèles automatiques et manuels
- Évaluation visuelle de la qualité des prévisions

## Résultats Principaux

L'analyse a révélé plusieurs points intéressants :

- Une corrélation positive modérée (0.4048) entre la température et le nombre total de locations
- Une cyclicité saisonnière marquée, avec des pics en été et des creux en hiver
- Une tendance à la hausse entre 2011 et 2013, avec une augmentation plus significative en été 2012
- Les utilisateurs enregistrés (corrélation: 0.46) sont légèrement plus influencés par la température que les utilisateurs occasionnels (corrélation: 0.34)
- Les modèles ARIMA ajustés manuellement semblent produire des prévisions plus cohérentes que les modèles ajustés automatiquement

## Comment Utiliser ce Projet

### Prérequis
Pour exécuter le code R, vous aurez besoin des packages suivants :
- tidyverse
- zoo
- tseries
- forecast
- lubridate

### Exécution
1. Assurez-vous d'avoir les données dans un dossier nommé "bike+sharing+dataset" avec les fichiers "hour.csv" et "day.csv"
2. Exécutez le script `projet_time_serie.R` dans R ou RStudio

## Conclusion

Ce projet démontre l'application des modèles de séries temporelles à un problème concret de prévision de demande pour un service de vélos en libre-service. Les méthodes utilisées peuvent être adaptées à d'autres problèmes similaires impliquant des données temporelles et des motifs saisonniers.
