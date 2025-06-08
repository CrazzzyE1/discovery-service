FROM maven:3.9.9-eclipse-temurin-17 AS builder
LABEL stage=builder
WORKDIR /build
COPY pom.xml .
RUN mvn dependency:go-offline -B
COPY src ./src
RUN mvn clean package -DskipTests

# === Stage 2: Run the application ===
FROM openjdk:17-jdk-slim
LABEL maintainer="litvak"

RUN apt-get update && apt-get install -y curl && apt-get clean && rm -rf /var/lib/apt/lists/*
COPY --from=builder /build/target/*.jar /app/application.jar
WORKDIR /app
EXPOSE 9031
ENTRYPOINT ["java", "-jar", "application.jar"]

