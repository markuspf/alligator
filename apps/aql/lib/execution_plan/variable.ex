defmodule Aql.ExecutionPlan.Variable do
  defstruct id: nil, is_full_document_from_collection: false, name: nil

  def parse_from_json(%{
        "id" => id,
        "isFullDocumentFromCollection" => is_full_document_from_collection,
        "name" => name
      }) do
    %__MODULE__{
      id: id,
      is_full_document_from_collection: is_full_document_from_collection,
      name: name
    }
  end
end
