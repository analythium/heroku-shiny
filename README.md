# Heroku deployment examples

## Prerequisites

- Install [Heroku CLI](https://devcenter.heroku.com/articles/heroku-cli#download-and-install)
- R & Shiny
- Docker

## Building Docker Images with heroku.yml

See docs: https://devcenter.heroku.com/articles/build-docker-images-heroku-yml

### Pieces

Create a `heroku.yml` file in your application's root directory. The following example heroku.yml specifies the Docker image to build for the app’s web process:

Heroku uses the `CMD` specified in the Dockerfile.

The Dockerfile defines system requirements, R package dependencies.

The /app folder contains the shiny app.

### Create app

See also here: https://github.com/virtualstaticvoid/heroku-docker-r

Create the Heroku application with the container stack

```bash
heroku create --stack=container
```

Now you should see the app url.

Or configure an existing application to use the container stack.

```bash
heroku stack:set container
```

### Deploy

Deploy your application to Heroku, replacing `<branch>` with your branch,
e.g. `main`:

```bash
git push heroku <branch>
```

Now you see the build logs on the Heroku remote

### Open app

Now open the app in your browser:

```bash
heroku open
```

## Local testing

To build the image from the Dockerfile, run:

```bash
sudo docker build -t analythium/heroku-demo .
```

Test locally:

```bash
docker run -p 4000:8080 analythium/heroku-demo
```
then visit `127.0.0.1:4000`.

(c) Copyright Analythium Solutions Inc, 2019-2020 (MIT).
