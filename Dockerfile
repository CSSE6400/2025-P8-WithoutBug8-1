FROM --platform=linux/amd64 ubuntu:24.04

ENV SQLALCHEMY_DATABASE_URI=sqlite:///:memory:

# Installing dependencies and cleaning up
RUN apt-get update && \
        apt-get install -y python3 pipx postgresql-client libpq-dev libcurl4-openssl-dev libssl-dev && \
        apt-get clean && \
        rm -rf /var/lib/apt/lists/*
RUN pipx ensurepath

# Install poetry
RUN pipx install poetry

# Setting the working directory
WORKDIR /app

# Install poetry dependencies
COPY pyproject.toml .
RUN pipx run poetry install --no-root

# Copying our application into the container
COPY bin bin
COPY todo todo

# Running our application
ENTRYPOINT ["/app/bin/docker-entrypoint.sh"]
CMD ["serve"]
