defmodule Abacus do
  @moduledoc """
  Documentation for `Abacus`.
  """

  def start(_type, _args) do
    children = [
      {GRPC.Server.Supervisor, endpoint: Abacus.Endpoint, port: 50000, start_server: true}
    ]

    opts = [strategy: :one_for_one, name: Abacus]
    Supervisor.start_link(children, opts)
  end

  @doc """
  Hello world.

  ## Examples

      iex> Abacus.hello()
      :world

  """
  def hello do
    :world
  end
end
