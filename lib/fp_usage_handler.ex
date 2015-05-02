defmodule FP.UsageHandler do
  use Timex
  require Logger

  @output_file "out/data.json"
  @store_count 2

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
        store_reports([report|reports])
        {[], 0}
      {reports, count} ->
        {[report|reports], count + 1}
    end)
  end

  @doc """
  Reads all the reports in the list.
  """
  def read(handler) do
    Logger.info "READ ALL <-"
    Agent.get(handler, fn {reports, _count} ->
      reports
    end)
  end

  defp store_reports(reports) do
    # Encode reports to JSON.
    json = Poison.Encoder.encode(reports, [])
    Logger.info "WRITING TO FILE #{@output_file} <- #{json}"

    # Write to file.
    {:ok, file} = File.open @output_file, [:write]
    IO.write file, json
    File.close @output_file
  end
end
