defmodule DeliveryCenterWeb.Item do
  use DeliveryCenterWeb, :model

  schema "item" do
    field(:externalCode, :string)
    field(:name, :string)
    field(:price, :float)
    field(:quantity, :integer)
    field(:total, :float)
    belongs_to(:order, DeliveryCenterWeb.Order)

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    array_of_fields = [
      :externalCode,
      :name,
      :price,
      :quantity,
      :total,
      :order_id
    ]

    struct
    |> cast(params, array_of_fields)
    |> validate_required(array_of_fields)
  end
end
