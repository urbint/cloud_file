defmodule CloudFile.DriverRegistry do
  @moduledoc """
  Registry for CloudFile drivers. Drivers must register here on initialization.

  """

  @default_drivers [CloudFile.Drivers.Local, CloudFile.Drivers.HTTP]
  @additional_drivers Application.get_env(:cloud_file, :additional_drivers, [])

  for driver <- @default_drivers ++ @additional_drivers do
    driver.init()

    for scheme <- driver.supported_schemes() do
      def get_driver(unquote(scheme)), do: unquote(driver)
    end
  end

  def get_driver(scheme), do: raise("No driver registered that supports the scheme: \"#{scheme}\"")
end
