defmodule P1.Processor do
  use ExUnit.Case

  def infinite_stream do
    Stream.cycle [1]
  end

  test "it should generate an output stream" do
    for x <- Processor.map(infinite_stream, fn x -> 2 * x end) |> Enum.take(100) do
      assert x == 2
    end
  end
end
