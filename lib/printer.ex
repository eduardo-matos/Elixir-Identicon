defmodule Identicon.Printer do
  def to_string(image) do
    colored_grid = Enum.map image.grid, fn (row) ->
      Enum.map row, fn(value) ->
        case value do
          true -> "■"
          false -> "□"
        end
      end
    end

    rows = for row <- colored_grid do
      Enum.join(row, " ")
    end

    Enum.join(rows, "\n")
  end

  def to_picture(image, size \\ 250) do
    pic = :egd.create(size, size)
    fill = :egd.color(image.color)

    Enum.with_index(image.grid) |> Enum.each(fn({row, row_index}) ->
      Enum.with_index(row) |> Enum.each(fn({cell, col_index}) ->
        if cell do
          top_left = {col_index * Kernel.trunc(size / 5), row_index * Kernel.trunc(size / 5)}
          bottom_right = {(col_index + 1) * Kernel.trunc(size / 5), (row_index + 1) * Kernel.trunc(size / 5)}
          :egd.filledRectangle(pic, top_left, bottom_right, fill)
        end
      end)
    end)

    :egd.render(pic)
  end
end