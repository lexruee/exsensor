defmodule ExSensor.I2C.Lmx do
  use Bitwise, only_operators: true
  require Logger

  import Circuits.I2C, only: [read: 3]
  alias Circuits.I2C

  @address 0x48

  @moduledoc """
  This is a software driver implementation for the Maxim LM75 temperature sensor.
  """

  @doc """
  Given the raw word data, it decodes the word into a 2-tuple.

  ## Examples

      iex> ExSensor.I2C.Lmx.decode_temperature(<<0x12, 0xE0>>)
      {0x12, 0xE0}
  """
  def decode_temperature(<<msb, lsb>>) do
    {msb, lsb}
  end

  @doc """
  Given the decoded raw data, it calculates the temperature value.

  ## Examples

      iex> ExSensor.I2C.Lmx.calculate_temperature({0x12, 0xE0})
      18.5
  """
  def calculate_temperature({msb, lsb}) do
    t0 = msb
    t1 = (lsb &&& 0x80) >>> 7 
    t0 + 0.5 * t1
  end

  def read_temperature({address, ref}) do
    #<<0xE0, 0x12>>
    {ok, <<msb, lsb>>} = I2C.read(ref, address, 2)
    <<msb, lsb>>
  end

  @doc """
  Given the sensor, it reads the temperature value.

  ## Examples

  """
  def temperature(sensor) do
    sensor
    |> read_temperature
    |> decode_temperature
    |> calculate_temperature
  end

  @doc """
  Given the decoded raw data, it calculates the temperature value.

  ## Examples

  """
  def create(ref, address \\ @address) do
    {address, ref}
  end
end
