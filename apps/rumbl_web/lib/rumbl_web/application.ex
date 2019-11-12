defmodule RumblWeb.Application do
  use Application

  def start(_type, _args) do
    children = [
      RumblWeb.Endpoint,
    ]

    opts = [strategy: :one_for_one, name: RumblWeb.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    RumblWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
