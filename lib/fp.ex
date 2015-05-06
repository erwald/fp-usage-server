defmodule FP do
  use Application

  def start(_type, _args) do
    FP.Supervisor.start_link
  end
end
