use Mix.Config

config :goth,
  json: File.read!("config/gcs_creds.json")

config :cloud_file,
  additional_drivers: [
    CloudFile.Driver.GCS,
  ]
