defmodule DeliveryCenter.Repo.Migrations.AddOrder do
  use Ecto.Migration

  def change do
    create table(:order) do
      add(:externalCode, :string)
      add(:storeId, :integer)
      add(:subTotal, :string)
      add(:deliveryFee, :string)
      add(:total, :string)
      add(:country, :string)
      add(:state, :string)
      add(:city, :string)
      add(:district, :string)
      add(:street, :string)
      add(:complement, :string)
      add(:latitude, :double)
      add(:longitude, :double)
      add(:dtOrderCreate, :string)
      add(:postalCode, :string)
      add(:number, :string)

      timestamps()
    end
  end
end
