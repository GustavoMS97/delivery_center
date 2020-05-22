defmodule DeliveryCenter.Repo.Migrations.AddItem do
  use Ecto.Migration

  def change do
    create table(:item) do
      add(:externalCode, :string)
      add(:name, :string)
      add(:price, :double)
      add(:quantity, :integer)
      add(:total, :double)
      add :order_id, references(:order)

      timestamps()
    end
  end
end
