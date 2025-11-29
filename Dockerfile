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

# CORRECCIÓN FINAL: Forzamos la clase principal con -cp (Classpath)
# Esto asegura que Java sepa qué archivo JAR es ejecutable,
# ignorando cualquier error en el manifiesto interno del JAR.
ENTRYPOINT ["java", "-cp", "app.jar", "com.example.eureka.EurekaApplication"]