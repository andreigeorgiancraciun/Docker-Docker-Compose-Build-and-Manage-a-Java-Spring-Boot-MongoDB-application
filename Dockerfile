FROM eclipse-temurin:11-jdk-focal
WORKDIR /emp
COPY gradle/ gradle/
COPY ./gradlew ./build.gradle ./settings.gradle ./gradle.properties ./sonar-project.properties .
RUN ./gradlew dependencies
COPY . .
ARG APP_VERSION="0.0.1"
RUN ./gradlew -Pprod -Pversion=$APP_VERSION clean bootJar
RUN mv build/libs/emp-$APP_VERSION.jar build/libs/emp.jar

FROM eclipse-temurin:11-jre-focal
COPY --from=0 /emp/build/libs/emp.jar /app/emp.jar
ENTRYPOINT ["java","-jar","/app/emp.jar"]
