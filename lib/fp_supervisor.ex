defmodule FP.Supervisor do
  use Supervisor
  require Logger

  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  @usage_handler_name FP.UsageHandler
  @router_name FP.Router

  def init(:ok) do
    Logger.info "Running FPUsageServer with Cowboy on http://localhost:4000"

    children = [
      worker(FP.UsageHandler, [[name: @usage_handler_name]]),
      Plug.Adapters.Cowboy.child_spec(:http, @router_name, [])
    ]

    supervise(children, strategy: :rest_for_one)
  end
end
