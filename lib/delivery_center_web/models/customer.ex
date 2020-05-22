defmodule DeliveryCenterWeb.Customer do
  use DeliveryCenterWeb, :model

  schema "customer" do
    field(:externalCode, :string)
    field(:name, :string)
    field(:email, :string)
    field(:contact, :string)
    belongs_to(:order, DeliveryCenterWeb.Order)

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    array_of_fields = [
      :externalCode,
      :name,
      :email,
      :contact,
      :order_id
    ]

    struct
    |> cast(params, array_of_fields)
    |> validate_required(array_of_fields)
  end
end
