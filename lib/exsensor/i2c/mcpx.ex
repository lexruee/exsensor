defmodule ExSensor.I2C.Mcpx do
  use Bitwise, only_operators: true

  import Circuits.I2C, only: [write_read: 4]
  alias Circuits.I2C

  @moduledoc """
  This is a software driver implementation for the Microchip MCP9808 
  temperature sensor.
  """

  @address 0x18
  @reg_temp 0x05

  @doc """
  Given the raw word data, it decodes the word into a 2-tuple.

  ## Examples

      iex> ExSensor.I2C.Mcpx.decode_temperature(<<0xC1, 0x41>>)
      {0xC1, 0x41}
  """
  def decode_temperature(<<msb, lsb>>) do
    {msb, lsb}
  end

  @doc """
  Given the decoded raw data, it calculates the temperature value.

  ## Examples

      iex> ExSensor.I2C.Mcpx.calculate_temperature({0xC1, 0x41})
      20.0625
  """
  def calculate_temperature({msb, lsb}) do
    word = ((msb <<< 8) ||| lsb)
    temperature = (word &&& 0x0FFF)
    offset = 256 * (word &&& 0x1000)
    temperature/16.0 - offset
  end

  def read_temperature({address, ref}) do
    #<<0xC1, 0x41>>
    {ok, <<msb, lsb>>} = I2C.write_read(ref, address, <<@reg_temp>>, 2)
    <<msb, lsb>>
  end

  def temperature(sensor) do
    sensor
    |> read_temperature
    |> decode_temperature
    |> calculate_temperature
  end

  def create(ref, address \\ @address) do
    {address, ref}
  end
end
