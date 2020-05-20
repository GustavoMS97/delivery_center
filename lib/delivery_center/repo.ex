defmodule DeliveryCenter.Repo do
  use Ecto.Repo,
    otp_app: :delivery_center,
    adapter: Ecto.Adapters.MyXQL
end
