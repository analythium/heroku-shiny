# Heroku deployment examples

## Prerequisites

- Install [Heroku CLI](https://devcenter.heroku.com/articles/heroku-cli#download-and-install)
- R & Shiny
- Docker

## Building Docker Images with heroku.yml

See docs: https://devcenter.heroku.com/articles/build-docker-images-heroku-yml

### Pieces

Create a `heroku.yml` file in your application's root directory. The following example heroku.yml specifies the Docker image to build for the app’s web process:

```yaml
build:
  docker:
    web: Dockerfile
```

Heroku uses the `CMD` specified in the Dockerfile.

The Dockerfile defines system requirements, R package dependencies.

```Dockerfile
FROM rocker/r-base:latest

RUN apt-get update && apt-get install -y --no-install-recommends \
    sudo \
    libcurl4-gnutls-dev \
    libcairo2-dev \
    libxt-dev \
    libssl-dev \
    libssh2-1-dev \
    && rm -rf /var/lib/apt/lists/*

RUN install.r shiny rmarkdown intrval

RUN addgroup --system app \
    && adduser --system --ingroup app app

WORKDIR /home/app

COPY app .

RUN chown app:app -R /home/app

USER app

EXPOSE 8080

ENV PORT=8080

CMD ["R", "-e", "shiny::runApp('/home/app', host = '0.0.0.0', port=as.numeric(Sys.getenv('PORT')))"]
```

The port settings and the `CMD` part is different from ShinyProxy apps,
port number is passed as an env var by the Heroku container runtime.

The `/app` folder contains the shiny app. The demo app was taken from here:
https://github.com/analythium/shinyproxy-demo

Note, Shiny apps [time out after 55 seconds](https://devcenter.heroku.com/articles/limits#http-timeouts):

> After the initial response, each byte sent from the server restarts a rolling 55 second window. A similar 55 second window is restarted for every byte sent from the client.
>
> If no data is received from the dyno within the 55 second window the connection is terminated and an H15 error is logged.
>
> Similarly, if no data is received from the client within the 55 second window, the connection is terminated and an H28 error is logged.

I workaround was posted on [SO](https://stackoverflow.com/questions/54594781/how-to-prevent-a-shiny-app-from-being-grayed-out) to print a dot to the console every passage of 10 seconds. 
A counter set at 50 seconds interval is added to `/app/server.R`.

### Create app

See also here: https://github.com/virtualstaticvoid/heroku-docker-r

Commit your changes if any:

```git
git commit -m "Changed"
```

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

https://morning-springs-64281.herokuapp.com/

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
