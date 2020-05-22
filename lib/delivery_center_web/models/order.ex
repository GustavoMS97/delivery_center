defmodule DeliveryCenterWeb.Order do
  use DeliveryCenterWeb, :model

  schema "order" do
    field(:externalCode, :string)
    field(:storeId, :integer)
    field(:subTotal, :string)
    field(:deliveryFee, :string)
    field(:total, :string)
    field(:country, :string)
    field(:state, :string)
    field(:city, :string)
    field(:district, :string)
    field(:street, :string)
    field(:complement, :string)
    field(:latitude, :float)
    field(:longitude, :float)
    field(:dtOrderCreate, :string)
    field(:postalCode, :string)
    field(:number, :string)

    has_many(:payment, DeliveryCenterWeb.Payment, foreign_key: :order_id)
    has_many(:item, DeliveryCenterWeb.Item, foreign_key: :order_id)
    has_many(:customer, DeliveryCenterWeb.Customer, foreign_key: :order_id)

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    array_of_fields = [
      :externalCode,
      :storeId,
      :subTotal,
      :deliveryFee,
      :total,
      :country,
      :state,
      :city,
      :district,
      :street,
      :complement,
      :latitude,
      :longitude,
      :dtOrderCreate,
      :postalCode,
      :number
    ]

    struct
    |> cast(params, array_of_fields)
    |> validate_required(array_of_fields)
  end
end
