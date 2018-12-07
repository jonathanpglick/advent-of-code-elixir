defmodule Day05 do

  def part1(input) do
    input
      |> String.replace("\n", "")
      |> String.split("", trim: true)
      |> react()
      |> Enum.join("")
      |> String.length()
  end

  def react(input) do
    input
      |> Enum.reduce([], fn char, buf ->
        last_index = Kernel.length(buf) - 1
        last = Enum.at(buf, last_index)
        cond do
          is_nil(last) -> [char]
          are_opposites(char, last) -> List.delete_at(buf, last_index)
          true -> buf ++ [char]
        end
      end)
  end

  def are_opposites(a, b) do
    Enum.all?([
      String.downcase(a) == String.downcase(b),
      Enum.any?([
        is_downcase(a) and is_upcase(b),
        is_upcase(a) and is_downcase(b),
      ])
    ])
  end

  def is_downcase(a) do
    String.downcase(a) == a
  end

  def is_upcase(a) do
    not is_downcase(a)
  end

  def part2(input) do
    input = input |> String.replace("\n", "")
    alphabet = input |> String.downcase() |> String.split("", trim: true) |> Enum.uniq()

    alphabet
    |> Enum.map(fn unit ->
      %{
        unit: unit,
        length: input |> remove_unit(unit) |> react() |> String.length()
      }
    end)
    |> Enum.sort_by(&Map.get(&1, :length))
    |> List.first()
    |> Map.get(:length)
  end

  def remove_unit(input, unit) do
    String.replace(input, [String.downcase(unit), String.upcase(unit)], "")
  end

end

input = File.read!("./day_05_input.txt")
#input = "dabAcCaCBAcCcaDA"

result1 = Day05.part1(input)
IO.write("\n")
IO.write("Result 1: ")
IO.inspect(result1)
IO.write("\n\n")

result2 = Day05.part2(input)
IO.write("Result 2: ")
IO.inspect(result2)
IO.write("\n\n")
