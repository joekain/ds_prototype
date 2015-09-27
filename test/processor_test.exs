defmodule P1.Processor do
  use ExUnit.Case

  def infinite_stream do
    fn -> Stream.cycle [1] end
  end

  def identity_processor do
    Processor.start_link(infinite_stream, fn x -> x end)
  end

  test "it should start a server" do
    {:ok, pid} = identity_processor
    assert is_pid(pid)
  end

  test "it should return items" do
    {:ok, pid} = identity_processor
    for _ <- 1..100 do
      item = Processor.next(pid)
      assert item == 1
    end
  end

  test "it should map the items" do
    {:ok, pid} = Processor.start_link(infinite_stream, fn x -> 2 * x end)
    for _ <- 1..100 do
      item = Processor.next(pid)
      assert item == 2
    end
  end

  test "it should generate an output stream" do
    for x <- Processor.map(infinite_stream, fn x -> 2 * x end) |> Enum.take(100) do
      assert x == 2
    end
  end
end
