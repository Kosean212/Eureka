# 1. ETAPA DE CONSTRUCCIÓN (BUILD STAGE)
FROM maven:3.9.5-amazoncorretto-21 AS build
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline
COPY src ./src
RUN mvn clean package -DskipTests
# ----------------------------------------------------
# 2. ETAPA FINAL (RUNTIME STAGE)
FROM amazoncorretto:21-alpine-jdk
ARG JAR_FILE=target/eureka-server.jar
COPY --from=build /app/${JAR_FILE} app.jar
EXPOSE 8761

# CORRECCIÓN FINAL: Usamos el comando estándar 'java -jar'
# El nombre de la clase principal ya fue fijado en el pom.xml.
ENTRYPOINT ["java", "-jar", "app.jar"]