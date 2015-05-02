defmodule FP.Router do
  use Plug.Router
  require Logger

  plug :match
  plug :dispatch

  get "/reports" do
    reports = Application.get_env(:fp, :handler) |> FP.UsageHandler.read
    send_resp(conn, 200, "#{inspect reports}")
  end

  # Receive a POST request with a report as its body.
  post "/report" do
    # Get and parse the report.
    {:ok, body, _conn} = Plug.Conn.read_body(conn)
    parsed_body = Poison.Parser.parse!(body)

    # Add the report to the handler.
    handler = Application.get_env(:fp, :handler)
    FP.UsageHandler.add(handler, parsed_body)

    send_resp(conn, 200, "success")
  end

  match _ do
    send_resp(conn, 404, "oops")
  end
end
