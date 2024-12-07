FROM elixir:alpine

WORKDIR /usr/bin/aletepelta

COPY . .

RUN mix deps.get

CMD ["mix", "test"]
