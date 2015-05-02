defmodule FP do
  use Application

  def start(_type, _args) do
    {:ok, handler} = FP.UsageHandler.start_link
    Application.put_env(:fp, :handler, handler)

    FP.Supervisor.start_link
  end
end
