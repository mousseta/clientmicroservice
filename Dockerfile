# Étape 1 : Build de l'application (Compilation avec Maven et Java 17)
# Utilise un tag très stable de Maven avec Temurin 17 pour la construction.
FROM maven:3.9.6-eclipse-temurin-17 AS builder
WORKDIR /app

# Meilleure pratique : copier uniquement ce qui est nécessaire pour optimiser le cache Docker
COPY pom.xml .
COPY src /app/src
# Si vous avez d'autres dossiers (comme resources, config, etc.), utilisez un 'COPY .' général
# COPY . . 

# Exécute la compilation
RUN mvn clean package -DskipTests

# Étape 2 : Image d'exécution (Runtime)
# CORRECTION : Utilisation de 'eclipse-temurin:17-jre-slim-bullseye'
# JRE est plus léger que le JDK et est suffisant pour exécuter l'application compilée.
FROM eclipse-temurin:17-jre-slim-bullseye
WORKDIR /app

# Copie l'artefact JAR compilé depuis l'étape 'builder'
COPY --from=builder /app/target/*.jar app.jar

# Expose le port par défaut de Spring Boot (si c'est 8080)
EXPOSE 8080

# Commande de lancement de l'application
ENTRYPOINT ["java", "-jar", "app.jar"]

