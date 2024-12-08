import Config

config :aletopelta, :web,
  tesla_complete_url: System.get_env("TESLA_COMPLETE_URL"),
  session_token: System.get_env("SESSION_TOKEN")

config :aletopelta, :day20241204,
  part1: System.get_env("DAY20241204_PART_1"),
  part2: System.get_env("DAY20241204_PART_2")

config :aletopelta, :day20241205,
  part1: System.get_env("DAY20241205_PART_1"),
  part2: System.get_env("DAY20241205_PART_2")

config :aletopelta, :day202412xx,
  part1: System.get_env("DAY202412xx_PART_1"),
  part2: System.get_env("DAY202412xx_PART_2")
