defmodule DeliveryCenter.Repo.Migrations.AddPayment do
  use Ecto.Migration

  def change do
    create table(:payment) do
      add(:type, :string)
      add(:value, :double)
      add :order_id, references(:order)

      timestamps()
    end
  end
end
