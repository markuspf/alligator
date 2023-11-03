defmodule Aql.Expression do
  @callback parse_details_from_json(json :: any()) :: any()

  def parse_from_json(%{"typeID" => 40} = json) do
    Aql.Expression.Value.parse_from_json(json)
  end

  defmacro __using__(fields) do
    quote do
      @behaviour Aql.Expression

      defstruct [
                  :type_id,
                  :type_name
                ] ++ unquote(fields)

      @type t :: %__MODULE__{
              type_id: integer(),
              type_name: binary()
            }

      def parse_from_json(
            %{
              "typeID" => type_id,
              "type" => type_name
            } = node
          ) do
        %__MODULE__{
          parse_details_from_json(node)
          | type_id: type_id,
            type_name: type_name
        }
      end
    end
  end
end
