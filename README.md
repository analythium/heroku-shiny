# Heroku deployment examples

## Prerequisites

- Install [Heroku CLI](https://devcenter.heroku.com/articles/heroku-cli#download-and-install)
- R & Shiny
- Docker

## Building Docker Images with heroku.yml

https://devcenter.heroku.com/articles/build-docker-images-heroku-yml

Create a `heroku.yml` file in your application's root directory. The following example heroku.yml specifies the Docker image to build for the app’s web process:

Heroku uses the `CMD` specified in the Dockerfile.

The Dockerfile defines system requirements, R package dependencies.

The /app folder contains the shiny app.


