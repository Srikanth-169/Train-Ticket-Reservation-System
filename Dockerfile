# ===== Build stage =====
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

# ===== Run stage (WAR in Tomcat) =====
FROM tomcat:9.0-jdk17
WORKDIR /usr/local/tomcat/webapps
COPY --from=build /app/target/*.war app.war
EXPOSE 8080
CMD ["catalina.sh", "run"]
