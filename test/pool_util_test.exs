defmodule PoolUtilTest do
  use ExUnit.Case

  test "it should collect via the the pool" do
    assert [2, 3, 4] ==
      [1, 2, 3]
      |> PoolUtil.map_through_pool(P1.pool_name())
      |> Enum.take(3)
      |> Enum.sort
  end
end
