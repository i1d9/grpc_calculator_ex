defmodule Abacist.Calculate do
  use GenServer

  require Logger

  def start_link(_) do
    GenServer.start_link(
      __MODULE__,
      %{channel: nil},
      name: __MODULE__
    )
  end

  @impl true
  def init(_current_state) do
    if Application.get_env(:abacist, __MODULE__, []) |> Keyword.get(:enabled, true) do
      Logger.info("[ABACUS] Starting...")

      connect()
    else
      # don't start if disabled
      :ignore
    end
  end

  @impl true
  def handle_info({:EXIT, _pid, _reason}, _conn) do
    Logger.error("[ABACUS] Client died")
    {:ok, channel} = connect()
    {:noreply, channel}
  end

  @impl true
  def handle_call({:calculate, %{a: a, b: b, type: type}}, _from, state) do
    state.channel
    |> Abacus.Calculator.Stub.calculate(%Abacus.ArithmeticRequest{
      a: a,
      b: b,
      type: type
    })
    |> case do
      {:ok, %Abacus.ArithmeticReply{result: result} = reply} ->
        Logger.info("""

        [ABACUS] Client Success:

        Result: #{inspect(reply)}

        """)

        result

      {:error, %GRPC.RPCError{status: status, message: message}} ->
        Logger.error("""
        [ABACUS] Client Error:

        Error Status: #{inspect(status)}

        Message: #{inspect(message)}

        """)

        {:error, message}

      _ ->
        0
    end
    |> then(&{:reply, {:ok, &1}, state})
  end

  def addition(a, b) do
    GenServer.call(__MODULE__, {:calculate, %{a: a, b: b, type: "addition"}})
  end

  def subtraction(a, b) do
    GenServer.call(__MODULE__, {:calculate, %{a: a, b: b, type: "subtraction"}})
  end

  def division(a, b) do
    GenServer.call(__MODULE__, {:calculate, %{a: a, b: b, type: "division"}})
  end

  def multiplication(a, b) do
    GenServer.call(__MODULE__, {:calculate, %{a: a, b: b, type: "division"}})
  end

  defp config() do
    Application.fetch_env!(:abacist, __MODULE__)
  end

  defp connect(timeout \\ 60_000) do
    hostname = config() |> Keyword.get(:hostname, "localhost:50000")

    Process.flag(:trap_exit, true)

    GRPC.Stub.connect(hostname)
    |> case do
      {:ok, channel} ->
        Logger.info("[ABACUS] Connected to #{hostname}!", ansi_color: :green)

        {:ok, %{channel: channel}}

      {:error, error} ->
        Logger.error(
          "[ABACUS] Client failed to start, retrying in #{trunc(timeout / 1000)} seconds:\n\t#{inspect(error, pretty: true)}"
        )

        Process.send_after(self(), :connect, timeout)
        {:ok, %{pid: nil}}
    end
  end
end
