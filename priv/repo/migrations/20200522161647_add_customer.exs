defmodule DeliveryCenter.Repo.Migrations.AddCustomer do
  use Ecto.Migration

  def change do
    create table(:customer) do
      add(:externalCode, :string)
      add(:name, :string)
      add(:email, :string)
      add(:contact, :string)
      add :order_id, references(:order)

      timestamps()
    end
  end
end
