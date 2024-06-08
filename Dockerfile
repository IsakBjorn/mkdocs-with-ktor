# Step 1: Build the MkDocs documentation
FROM python:3.9-slim as mkdocs-builder

RUN pip install mkdocs-material

COPY docs/ /mkdocs/docs
COPY mkdocs.yml /mkdocs

WORKDIR /mkdocs
RUN mkdocs build

# Step 2: Build the Ktor application
FROM maven:3.9.7-eclipse-temurin-21-alpine as builder

COPY server /server
COPY --from=mkdocs-builder /mkdocs/site /server/src/main/resources/static

WORKDIR /server
RUN mvn clean package

# Step 3: Create the final image
FROM eclipse-temurin:21.0.3_9-jre-ubi9-minimal

RUN mkdir /app
COPY --from=builder /server/target/*.jar /app/server.jar

EXPOSE 8080:8080
ENTRYPOINT ["java", "-jar", "/app/server.jar"]
