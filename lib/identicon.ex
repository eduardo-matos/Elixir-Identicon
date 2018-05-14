defmodule Identicon do
  def generate(input) do
    generate_hash(input)
      |> pick_color
      |> generate_grid
  end

  def generate_hash(input) do
    hash =
    :crypto.hash(:md5, input)
      |> :binary.bin_to_list

    %Identicon.Image{hex: hash}
  end

  def pick_color(%Identicon.Image{hex: [r, g, b | _tail]} = image) do
    %Identicon.Image{image | color: {r, g, b}}
  end

  def generate_grid(%Identicon.Image{hex: hash} = image) do
    grid = 
      Enum.chunk(hash, 3)
        |> Enum.map(&mirror/1)
        |> Enum.map(&fill/1)

    %Identicon.Image{image | grid: grid}
  end

  def mirror(row) do
    [col1, col2 | _tail] = row
    row ++ [col2, col1]
  end

  def fill(row) do
    Enum.map row, fn(value) -> rem(value, 2) == 0 end
  end
end
