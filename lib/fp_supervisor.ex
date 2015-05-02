defmodule FP.Supervisor do
  use Supervisor
  require Logger

  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  @router_name FP.Router

  def init(:ok) do
    Logger.info "Running FPUsageServer with Cowboy on http://localhost:4000"

    children = [
      Plug.Adapters.Cowboy.child_spec(:http, FP.Router, [])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
