defmodule CloudFile.DriverRegistry do
  @moduledoc """
  Registry for CloudFile drivers. Drivers must register here on initialization.

  """

  use GenServer


  # Client API

  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @spec get_driver(CloudFile.scheme) :: {:ok, CloudFile.driver} | {:error, CloudFile.reason}
  def get_driver(scheme) do
    GenServer.call(__MODULE__, {:get_driver, scheme})
  end


  # Server API

  def init(:ok) do
    default_drivers =
      [CloudFile.Drivers.Local, CloudFile.Drivers.HTTP]

    additional_drivers =
      Application.get_env(:cloud_file, :additional_drivers, [])

    drivers =
      default_drivers ++ additional_drivers
      |> Enum.map(fn driver -> driver.init(); driver; end)
      |> Enum.flat_map(&get_scheme_and_driver/1)
      |> Map.new()

    {:ok, drivers}
  end

  def handle_call({:get_driver, scheme}, _from, drivers) do
    case Map.get(drivers, scheme) do
      nil    -> {:reply, {:error, "No driver registered that supports the scheme: \"#{scheme}\""}, drivers}
      driver -> {:reply, {:ok, driver}, drivers}
    end
  end

  @spec get_scheme_and_driver(CloudFile.driver) :: [{CloudFile.scheme, CloudFile.driver}]
  defp get_scheme_and_driver(driver) do
    driver.supported_schemes()
    |> Enum.map(& {&1, driver})
  end
end
