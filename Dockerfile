FROM rocker/r-base:latest

LABEL maintainer="Peter Solymos <peter@analythium.io>"

RUN apt-get update && apt-get install -y --no-install-recommends \
    sudo \
    libcurl4-gnutls-dev \
    libcairo2-dev \
    libxt-dev \
    libssl-dev \
    libssh2-1-dev \
    && rm -rf /var/lib/apt/lists/*

RUN install.r shiny rmarkdown intrval

# create non rrot user
RUN addgroup --system app \
    && adduser --system --ingroup app app

# copy contents of /app directory
WORKDIR /home/app

COPY app .

RUN chown app:app -R /home/app

USER app

# EXPOSE can be used for local testing, not supported in Heroku's container runtime
#EXPOSE 8080

# web process/code should get the $PORT environment variable
#ENV PORT=8080

CMD ["R", "-e", "shiny::runApp('/home/app', host = '0.0.0.0', port=Sys.getenv('PORT'))"]
