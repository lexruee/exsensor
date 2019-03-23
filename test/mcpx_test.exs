defmodule ExSensor.McpxTest do
  use ExUnit.Case
  alias ExSensor.I2C.Mcpx
  doctest Mcpx

  setup do
    [ 
      word1: <<0xC1, 0x41>>, temperature1: 20.0625, decoded1: {0xC1, 0x41},
    ]
  end

  test "decode temperature word", fixture do
    assert Mcpx.decode_temperature(fixture.word1) == fixture.decoded1
  end

  test "calculate temperarure", fixture do
    assert Mcpx.calculate_temperature(fixture.decoded1) == fixture.temperature1
  end

  test "create sensor" do
    assert {0x18, _} = Mcpx.create(:ref, 0x18)
  end

end
