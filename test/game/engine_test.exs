defmodule Game.EngineTest do
  use Game.DataCase, async: true

  alias Game.Engine
  alias Game.State.Players.Player

  test "can detect collision between two players" do
    game_objects = [
      %Player{id: 1, x: 100, y: 100, name: "frank"},
      %Player{id: 2, x: 120, y: 120, name: "kurz nach frank"}
    ]

    assert %{{Player, 1} => [{Player, 2}], {Player, 2} => [{Player, 1}]} =
             Engine.detect_collisions(game_objects)
  end

  test "can detect collision between multiple players" do
    game_objects = [
      %Player{id: 1, x: 100, y: 100, name: "frank"},
      %Player{id: 2, x: 120, y: 120, name: "kurz nach frank"},
      %Player{id: 3, x: 80, y: 80, name: "kurz vor frank"},
      %Player{id: 4, x: 120, y: 140, name: "definitely not frank"}
    ]

    assert %{
             {Player, 1} => [{Player, 3}, {Player, 2}],
             {Player, 2} => [{Player, 4}, {Player, 1}],
             {Player, 3} => [{Player, 1}]
           } = Engine.detect_collisions(game_objects)
  end

  test "no collisions returns nil" do
    game_objects = [
      %Player{id: 1, x: 10, y: 100, name: "frank"},
      %Player{id: 2, x: 110, y: 110, name: "kurz nach frank"},
      %Player{id: 3, x: 900, y: 90, name: "kurz vor frank"}
    ]

    assert nil == Engine.detect_collisions(game_objects)
  end
end