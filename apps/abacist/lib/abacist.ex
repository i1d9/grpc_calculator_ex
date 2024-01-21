defmodule Abacist do
  use Application

  @moduledoc """
  Documentation for `Abacist`.
  """

  def start(_type, _args) do
    children = [
      Abacist.Calculate
    ]

    opts = [strategy: :one_for_one, name: Abacist]
    Supervisor.start_link(children, opts)
  end

  @doc """
  Hello world.

  ## Examples

      iex> Abacist.hello()
      :world

  """
  def hello do
    :world
  end
end
