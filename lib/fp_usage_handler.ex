defmodule FP.UsageHandler do
  use Timex
  require Logger

  @output_folder "out/"
  @store_count 10

  @doc """
  Starts a new usage statistics handler.
  """
  def start_link do
    Logger.info "START"
    Agent.start_link(fn -> {[], 0} end)
  end

  @doc """
  Adds a new report to the list.
  """
  def add(handler, report) do
    Logger.info "ADD -> #{inspect report}"
    Agent.update(handler, fn
      {reports, count} when (count + 1) >= @store_count ->
        store_reports([format_report(report) | reports])
        {[], 0}
      {reports, count} ->
        {[format_report(report) | reports], count + 1}
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

  defp store_reports(reports) do
    # Encode reports to JSON.
    json = Poison.Encoder.encode(reports, [])
    Logger.info "WRITING TO FILE #{file_path} <- #{json}"

    # Write to file.
    {:ok, file} = File.open file_path, [:write]
    IO.write file, json
    File.close file_path
  end

  defp stored_reports do
    File.ls!(@output_folder)
    |> Enum.filter(fn file -> String.match?(file, ~r/.+\.json$/) end)
    |> parse_jsons
  end

  defp parse_jsons(files) do
    Enum.map(files, fn file ->
      "#{@output_folder}#{file}"
      |> File.read!
      |> Poison.Parser.parse!
    end)
  end

  defp format_report(report) do
    %{"time" => time} = report
    date = Date.from(String.to_float(time), :secs)
    %{report | "time" => DateFormat.format!(date, "{ISO}")}
  end

  defp file_path do
    date = DateFormat.format!(Date.local, "{ISOz}")
    "#{@output_folder}#{date}.json"
  end
end
