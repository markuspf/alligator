defmodule Tui.ColumnFamilyBrowser do
  @behaviour Ratatouille.App

  import Ratatouille.Constants, only: [key: 1]
  import Ratatouille.View

  alias Ratatouille.Runtime.Command

  @arrow_up key(:arrow_up)
  @arrow_down key(:arrow_down)

  @header "Column Family Browser"

  def init(context) do
    model = %{
      key_cursor: 0,
      column_family: StorageEngine.RocksDB.open_test_cf()
    }

    model
  end

  def update(
        %{
          key_cursor: key_cursor,
          column_family: column_family
        } = model,
        msg
      ) do
    case msg do
      {:event, %{key: key}} when key in [@arrow_up, @arrow_down] ->
        new_cursor =
          case key do
            @arrow_up -> max(key_cursor - 1, 0)
            @arrow_down -> min(key_cursor + 1, length(column_family) - 1)
          end

        new_model = %{model | key_cursor: new_cursor}
        new_model

      _ ->
        model
    end
  end

  def render(model) do
    {key, value} = Enum.at(model.column_family, model.key_cursor)

    menu_bar =
      bar do
        label(content: "Browsing Column Familyt \"default\"", color: :blue)
      end

    view(top_bar: menu_bar) do
      row do
        column(size: 5) do
          panel(title: "Keys", height: :fill) do
            viewport(offset_y: model.key_cursor) do
              for {{key, _}, idx} <- Enum.with_index(model.column_family) do
                fkey =
                  Base.encode16(key, case: :lower)
                  |> to_charlist
                  |> Enum.chunk_every(2)
                  |> Enum.join(" ")

                if idx == model.key_cursor do
                  label(content: "> #{fkey}", color: :red, attributes: [:bold])
                else
                  label(content: "  #{fkey}")
                end
              end
            end
          end
        end

        column(size: 7) do
          panel(title: "type of entry", height: :fill) do
            label(
              content:
                case VelocyPack.decode(value) do
                  {:ok, dict} ->
                    Inspect.inspect(dict, %Inspect.Opts{})
                    |> Inspect.Algebra.format(50)
                    |> IO.iodata_to_binary()

                  {:error, _} ->
                    "bad"
                end
            )
          end
        end
      end
    end
  end
end
