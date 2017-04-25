defmodule CloudFile.DriverRegistry do
  @moduledoc """
  Registry for CloudFile drivers. Drivers must register here on initialization.

  """

  def get_driver(nil), do: CloudFile.Driver.Local
  def get_driver("http"), do: CloudFile.Driver.HTTP
  def get_driver("https"), do: CloudFile.Driver.HTTP

  @drivers Application.get_env(:cloud_file, :additional_drivers, [])

  for driver <- @drivers do
    for scheme <- driver.supported_schemes() do
      def get_driver(unquote(scheme)), do: unquote(driver)
    end
  end

  def get_driver(scheme), do: raise("No driver registered that supports the scheme: \"#{scheme}\"")
end
