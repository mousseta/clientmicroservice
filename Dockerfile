# Étape 1 : Compilation avec Maven et Java 17
FROM maven:3.8-openjdk-17 AS builder
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

# Étape 2 : Image d'exécution plus légère avec OpenJDK seul
FROM eclipse-temurin:17-jre-focal
WORKDIR /app
COPY --from=builder /app/target/*.jar app.jar
ENTRYPOINT [\"java\", \"-jar\", \"app.jar\"]