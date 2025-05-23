FROM elixir:alpine

WORKDIR /usr/bin/aletopelta

ENV TESLA_COMPLETE_URL=https://adventofcode.com/ \
SESSION_TOKEN=session= \
DAY20241204_PART_1= \
DAY20241204_PART_2= \
DAY20241205_PART_1= \
DAY20241205_PART_2= \
DAY20241206_PART_1= \
DAY20241206_PART_2= \
DAY20241207_PART_1= \
DAY20241207_PART_2= \
DAY20241208_PART_1= \
DAY20241208_PART_2= \
DAY20241209_PART_1= \
DAY20241209_PART_2= \
DAY20241210_PART_1= \
DAY20241210_PART_2= \
DAY20241211_PART_1= \
DAY20241211_PART_2= \
DAY20241212_PART_1= \
DAY20241212_PART_2= \
DAY20241213_PART_1= \
DAY20241213_PART_2= \
DAY20241214_PART_1= \
DAY20241214_PART_2= \
DAY20241215_PART_1= \
DAY20241215_PART_2= \
DAY20241216_PART_1= \
DAY20241216_PART_2= \
DAY20241217_PART_1= \
DAY20241217_PART_2= \
DAY20241218_PART_1= \
DAY20241218_PART_2= \
DAY20241219_PART_1= \
DAY20241219_PART_2= \
DAY20241220_PART_1= \
DAY20241220_PART_2= \
DAY20241221_PART_1= \
DAY20241221_PART_2= \
DAY20241222_PART_1= \
DAY20241222_PART_2= \
DAY20241223_PART_1= \
DAY20241223_PART_2= \
DAY20241224_PART_1= \
DAY20241224_PART_2= \
DAY20241225_PART_1= \
DAY20241225_PART_2= \
DAY202412xx_PART_1= \
DAY202412xx_PART_2= \
JUNK=3

ARG day

COPY config/ config/
COPY test/aletopelta_test.exs test/aletopelta_test.exs
COPY test/test_helper.exs test/test_helper.exs
COPY lib/aletopelta.ex lib/aletopelta.ex
COPY mix.exs mix.exs

COPY test/day${day}_test.exs test/main_test.exs
COPY lib/day${day}.ex lib/main.ex

RUN mix deps.get

CMD ["mix", "test", "--only", "current"]
