defmodule DriverRegistry do
  @moduledoc """
  Registry for Cloudfile drivers. Drivers must register here on initialization.

  """

  use GenServer


  # Public API

  def start_link do
    GenServer.start_link(__MODULE__, :ok, [])
  end


  @doc """
  Outputs a list of the registers drivers.

  """
  def to_list(server) do
    GenServer.call(server, {:to_list})
  end


  @doc """
  Registers a driver with the Driver Registry.

  """
  def register(server, driver) do
    GenServer.cast(server, {:register, driver})
  end


  @doc """
  Checks if a `driver` is registered.

  """
  def registered?(server, driver) do
    GenServer.call(server, {:check_registration, driver})
  end


  # Server API

  def init(:ok) do
    {:ok, MapSet.new()}
  end

  def handle_call({:to_list}, _from, drivers) do
    {:reply, MapSet.to_list(drivers), drivers}
  end

  def handle_cast({:register, driver}, drivers) do
    {:noreply, MapSet.put(drivers, driver)}
  end

  def handle_call({:check_registration, driver}, _from, drivers) do
    {:reply, MapSet.member?(drivers, driver), drivers}
  end


end
