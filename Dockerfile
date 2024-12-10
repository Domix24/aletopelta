FROM elixir:alpine

WORKDIR /usr/bin/aletopelta

COPY . .

RUN mix deps.get

CMD ["mix", "test"]
