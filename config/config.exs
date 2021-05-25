import Config

config :pollution, Pollution.Repo,
  database: "pollution_repo",
  username: "postgres",
  password: "pass",
  hostname: "localhost"

config :pollution, ecto_repos: [Pollution.Repo]

