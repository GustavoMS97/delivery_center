defmodule DeliveryCenterWeb.Payment do
  use DeliveryCenterWeb, :model

  schema "payment" do
    field(:type, :string)
    field(:value, :float)
    belongs_to(:order, DeliveryCenterWeb.Order)

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    array_of_fields = [
      :type,
      :value,
      :order_id
    ]

    struct
    |> cast(params, array_of_fields)
    |> validate_required(array_of_fields)
  end
end
