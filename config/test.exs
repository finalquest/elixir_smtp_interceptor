import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :smtp_interceptor, SmtpInterceptorWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "Fpz0NRCYVRGBIa6yWR5fBjYlD1QlJz6e9R1Z7fwTfTG/OL0RAuU40o7jRUTQF4KR",
  server: false

# In test we don't send emails.
config :smtp_interceptor, SmtpInterceptor.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
