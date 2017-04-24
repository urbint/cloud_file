defmodule DriverRegistryTest do
  use ExUnit.Case, async: true
  doctest DriverRegistry

  setup do
    {:ok, registry} = DriverRegistry.start_link()
    {:ok, registry: registry}
  end

  describe "register/2" do
    test "is empty initially", %{registry: registry} do
      assert DriverRegistry.to_list(registry) == []
    end

    test "registers a driver module", %{registry: registry} do
      DriverRegistry.register(registry, MockDriver)
      assert DriverRegistry.to_list(registry) == [MockDriver]
    end
  end

  describe "registered?/2" do
    test "returns false if a driver is not registered", %{registry: registry} do
      refute DriverRegistry.registered?(registry, MockDriver)
    end

    test "returns true if a driver is registered", %{registry: registry} do
      refute DriverRegistry.registered?(registry, MockDriver)
      DriverRegistry.register(registry, MockDriver)
      assert DriverRegistry.registered?(registry, MockDriver)
    end
  end
end


defmodule MockDriver do
  @moduledoc """
  Mock Driver to `DriverRegistryTest`

  """
  @behaviour Cloudfile.Driver

  defdelegate read(path), to: File

  def write(path, content) do
    File.write(path, content, [])
  end

  defdelegate rm(path), to: File
end
