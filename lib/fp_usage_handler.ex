defmodule FP.UsageHandler do
  use Timex
  require Logger

  # The folder (from project root) where reports are saved.
  @output_folder "../out/"

  # The interval (in milliseconds) after which the storing of reports to file
  # are triggered.
  @saving_interval 10000

  @doc """
  Starts a new usage statistics handler.
  """
  def start_link do
    Logger.info "START"
    Agent.start_link(fn -> {[], nil} end)
  end

  @doc """
  Adds a new report to the list.
  """
  def add(handler, report) do
    Logger.info "ADD -> #{inspect report}"
    Agent.update(handler, fn
      {reports, timer} ->
        {[format_report(report) | reports], reset_timer(timer, handler)}
    end)
  end

  @doc """
  Reads all the reports in the list.
  """
  def read(handler) do
    Logger.info "READ ALL <-"
    stored_reports ++ Agent.get(handler, fn {reports, _} ->
      reports
    end)
  end

  @doc """
  Stores all of the reports in state, if any, to file.
  """
  def get_and_store_reports(handler) do
    Agent.update(handler, fn
      {reports, timer} when length(reports) == 0 -> {reports, timer}
      {reports, timer} ->
        store_reports(reports)
        {[], timer}
    end)
  end

  # Stores a list of reports to a file.
  defp store_reports(reports) do
    # Encode reports to JSON.
    json = Poison.Encoder.encode(reports, [])

    # Write to file.
    file_path = make_file_path
    {:ok, file} = File.open file_path, [:write]
    IO.write file, json
    File.close file_path

    Logger.info "WROTE #{length reports} REPORTS TO FILE -> #{file_path}"
  end

  # Starts or restarts a timer which will trigger the storing of reports in
  # state, if any, to file. Returns a reference to the timer.
  defp reset_timer(timer, handler) do
    if timer, do: :timer.cancel(timer) # Cancel the previous timer.
    {:ok, tref} = :timer.apply_after(@saving_interval, FP.UsageHandler,
      :get_and_store_reports, [handler])
    tref
  end

  # Gets all of the reports stored in files.
  defp stored_reports do
    File.ls!(Path.join(__DIR__, @output_folder))
    |> Enum.filter(&String.match?(&1, ~r/.+\.json$/))
    |> parse_jsons
    |> List.flatten
  end

  # Takes a list of file names and returns a list of maps.
  defp parse_jsons(files) do
    Enum.map(files, fn file ->
      Path.join([__DIR__, @output_folder, file])
      |> File.read!
      |> Poison.Parser.parse!
    end)
  end

  # Formats a report by converting dates from epochs to ISO standard.
  defp format_report(report) do
    %{"time" => time} = report
    date = Date.from(String.to_float(time), :secs)
    %{report | "time" => DateFormat.format!(date, "{ISO}")}
  end

  # Generates a file path for a new file.
  defp make_file_path do
    date = DateFormat.format!(Date.local, "{ISOz}")
    Path.join([__DIR__, @output_folder, "#{date}.json"])
  end
end
