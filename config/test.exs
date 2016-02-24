use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :mr_rebase, MrRebase.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :info

# Configure your database
config :mr_rebase, MrRebase.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "mr_rebase_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :mr_rebase, :github_api, GitHub.Fake

defmodule CustomFormatter do
  import ExUnit.Formatter, only: [format_time: 2]

  defdelegate init(opts), to: ExUnit.CLIFormatter
  defdelegate trace_test_skip(test), to: ExUnit.CLIFormatter

  def handle_event({:test_finished, %ExUnit.Test{state: {:skip, _}} = test}, config) do
    if config.trace do
      IO.puts skipped(trace_test_skip(test), config)
    else
      IO.write skipped("S", config)
    end
    {:ok, %{config | tests_counter: config.tests_counter + 1,
                     skipped_counter: config.skipped_counter + 1}}
  end

  def handle_event({:suite_finished, run_us, load_us}, config) do
    print_suite(config, run_us, load_us)
    :remove_handler
  end

  defdelegate handle_event(event, config), to: ExUnit.CLIFormatter

  defp colorize(escape, string, %{colors: colors}) do
    enabled = colors[:enabled]
    [IO.ANSI.format_fragment(escape, enabled),
     string,
     IO.ANSI.format_fragment(:reset, enabled)] |> IO.iodata_to_binary
  end

  defp skipped(msg, config) do
    colorize([:yellow], msg, config)
  end

  defp print_suite(config, run_us, load_us) do
    IO.write "\n\n"
    IO.puts format_time(run_us, load_us)

    # singular/plural
    test_pl = pluralize(config.tests_counter, "test", "tests")
    failure_pl = pluralize(config.failures_counter, "failure", "failures")

    message =
      "#{config.tests_counter} #{test_pl}, #{config.failures_counter} #{failure_pl}"
      |> if_true(config.skipped_counter > 0, & &1 <> ", #{config.skipped_counter} skipped")
      |> if_true(config.invalids_counter > 0, & &1 <> ", #{config.invalids_counter} invalid")

    cond do
      config.failures_counter > 0 -> IO.puts failure(message, config)
      config.invalids_counter > 0 -> IO.puts invalid(message, config)
      config.skipped_counter  > 0 -> IO.puts skipped(message, config)
      true                        -> IO.puts success(message, config)
    end

    IO.puts "\nRandomized with seed #{config.seed}"
  end

  defp pluralize(1, singular, _plural), do: singular
  defp pluralize(_, _singular, plural), do: plural

  defp if_true(value, false, _fun), do: value
  defp if_true(value, true, fun), do: fun.(value)

  defp success(msg, config) do
    colorize([:green], msg, config)
  end

  defp invalid(msg, config) do
    colorize([:yellow], msg, config)
  end

  defp failure(msg, config) do
    colorize([:red], msg, config)
  end
end

config :ex_unit, formatters: [CustomFormatter]
