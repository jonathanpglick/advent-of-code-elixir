defmodule Day03 do
  def part1(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_claim(&1))
    |> Enum.flat_map(&Map.get(&1, :tokens))
    |> Enum.reduce(%{}, fn token, acc -> Map.update(acc, token, 1, &(&1 + 1)) end)
    |> Enum.filter(fn {_token, count} -> count >= 2 end)
    |> Enum.count()
  end

  def parse_claim(claim_string) do
    claim_parts = claim_string |> String.split(" ")

    coordinates =
      claim_parts
      |> Enum.at(2)
      |> String.replace(":", "")
      |> String.split(",")
      |> Enum.map(&String.to_integer(&1))

    size =
      claim_parts
      |> Enum.at(3)
      |> String.split("x")
      |> Enum.map(&String.to_integer(&1))

    claim = %{
      :id => Enum.at(claim_parts, 0),
      :x => Enum.at(coordinates, 0),
      :y => Enum.at(coordinates, 1),
      :w => Enum.at(size, 0),
      :h => Enum.at(size, 1),
      :tokens => nil
    }

    Map.put(claim, :tokens, claim_to_tokens(claim))
  end

  def claim_to_tokens(%{x: x_start, y: y_start, w: w, h: h}) do
    x_end = x_start + w - 1
    y_end = y_start + h - 1

    Enum.flat_map(y_start..y_end, fn y ->
      Enum.map(x_start..x_end, fn x ->
        space_token(x, y)
      end)
    end)
  end

  def space_token(x, y) do
    Integer.to_string(x) <> "," <> Integer.to_string(y)
  end

  def part2(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_claim(&1))
    |> Enum.map(fn claim -> Map.put(claim, :tokens_set, MapSet.new(Map.get(claim, :tokens))) end)
    |> find_non_overlapping_claim()
  end

  def find_non_overlapping_claim(claims) do
    claims
    |> Enum.filter(fn claim -> not claim_overlaps_with_claims(claim, claims) end)

    # |> List.first()
  end

  def claim_overlaps_with_claims(claim, claims) do
    claims
    |> Enum.filter(fn claim1 -> not Map.equal?(claim1, claim) end)
    |> Enum.any?(&claim_overlaps_with_claim(&1, claim))
  end

  def claim_overlaps_with_claim(claim1, claim2) do
    not MapSet.disjoint?(
      Map.get(claim1, :tokens_set),
      Map.get(claim2, :tokens_set)
    )
  end
end

input = File.read!("./day_03_input.txt")
# input = "#1 @ 1,3: 4x4\n#2 @ 3,1: 4x4\n#3 @ 5,5: 2x2"
result1 = Day03.part1(input)

IO.write("\n")
IO.write("Number of square inches of fabric used: " <> Integer.to_string(result1))
IO.write("\n\n")

result2 = Day03.part2(input)

IO.write("\n")
IO.write("Claim that doesn't overlap:\n")
IO.inspect(result2)
IO.write("\n\n")
