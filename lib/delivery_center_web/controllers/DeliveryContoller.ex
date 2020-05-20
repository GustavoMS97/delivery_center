defmodule DeliveryCenterWeb.DeliveryController do
  use DeliveryCenterWeb, :controller

  def index(conn, _params) do
    conn
    |> put_status(200)
    |> json(%{code: "200", reason_given: "None."})
  end
end
