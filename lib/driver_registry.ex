defmodule DriverRegistry do
  @moduledoc """
  Registry for Cloudfile drivers. Drivers must register here on initialization.

  The registry
  %{scheme => Module}

  """

  use GenServer


  # Client API

  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end


  @doc """
  Returns the driver module for the path beginning with `scheme`.

  """
  @spec
  def get_driver(scheme) do
    GenServer.call(__MODULE__, {:get_driver, scheme})
  end


  @doc """
  Registers a driver.

  """
  def register(driver) do
    GenServer.cast(__MODULE__, {:register, driver})
  end


  @doc """
  Returns `true` if a `driver` is registered.

  """
  def registered?(driver) do
    GenServer.call(__MODULE__, {:check_registration, driver})
  end


  # Server API

  def init(:ok) do
    {:ok, %{}}
  end


  def handle_call({:get_driver, scheme}, _from, drivers) do
    {:reply, Map.get(drivers, scheme), drivers}
  end


  # Note: when no schemes are supported (i.e. []), `nil` becomes the key
  def handle_call({:check_registration, driver}, _from, drivers) do
    registered? =
      case driver.supported_schemes() do
        []      -> Map.has_key?(drivers, nil)
        schemes -> Enum.all?(schemes, &Map.has_key?(drivers, &1))
      end

    {:reply, registered?, drivers}
  end


  # Note: when no schemes are supported (i.e. []), `nil` becomes the key
  def handle_cast({:register, driver}, drivers) do
    updated_drivers =
      case driver.supported_schemes() do
        []      -> register_scheme(nil, driver, drivers)
        schemes -> register_schemes(schemes, driver, drivers)
      end

    {:noreply, updated_drivers}
  end

  defp register_scheme(scheme, driver, drivers) do
    Map.put(drivers, scheme, driver)
  end

  defp register_schemes(schemes, driver, drivers) do
    Enum.reduce(schemes, drivers, &register_scheme(&1, driver, &2))
  end


end
