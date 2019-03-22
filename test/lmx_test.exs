defmodule ExSensor.LmxTest do
  use ExUnit.Case
  alias ExSensor.I2C.Lmx
  doctest Lmx

  setup do
    [ 
      word1: <<0x12, 0xE0>>, temperature1: 18.5, decoded1: {0x12, 0xE0},
      word2: <<0xC0, 0x13>>, temperature2: 19.5,
      word3: <<0x00, 0x16>>, temperature3: 22.0,
      word4: <<0x80, 0x15>>, temperature4: 21.5,
    ]
  end

  test "decode temperature word", fixture do
    assert Lmx.decode_temperature(fixture.word1) == fixture.decoded1
  end

  test "calculate temperarure", fixture do
    assert Lmx.calculate_temperature(fixture.decoded1) == fixture.temperature1
  end

  test "create sensor" do
    assert {0x48, _} = Lmx.create(:ref, 0x48)
  end
end
