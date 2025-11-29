# 1. ETAPA DE CONSTRUCCIÓN (BUILD STAGE)
# Usamos una imagen base de Maven con JDK 21 para compilar.
FROM maven:3.9.5-amazoncorretto-21 AS build

# Establecemos el directorio de trabajo dentro del contenedor
WORKDIR /app


# Copiamos el pom.xml y descargamos dependencias
COPY pom.xml .

# Descargamos las dependencias
RUN mvn dependency:go-offline

# Copiamos el código fuente
COPY src ./src

# Compilamos y generamos el JAR
# El archivo JAR generado es: eureka-0.0.1-SNAPSHOT.jar
RUN mvn clean package -DskipTests

# ----------------------------------------------------
# 2. ETAPA FINAL (RUNTIME STAGE)
# Usamos una imagen más ligera (solo el JRE) para el runtime.
FROM amazoncorretto:21-alpine-jdk

# Define el nombre del JAR (Coincide con <artifactId>-<version>.jar)
ARG JAR_FILE=target/eureka-server.jar

# Copiamos el archivo JAR compilado desde la etapa de construcción
COPY --from=build /app/${JAR_FILE} app.jar

# El puerto estándar de Eureka (8761)
EXPOSE 8761

# Comando de entrada para ejecutar la aplicación
# Usamos java -jar app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]