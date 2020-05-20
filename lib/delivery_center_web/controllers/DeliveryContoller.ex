defmodule DeliveryCenterWeb.DeliveryController do
  use DeliveryCenterWeb, :controller

  def index(conn, _params) do
    conn
    |> put_status(200)
    |> json(%{code: "200", reason_given: "None."})
  end

  def create(conn, _params) do
    # Extrair dados do corpo da requisição - OK
    # persistir dados que chegaram
    # Criar objeto do corpo esperado pela requisição
    # Enviar requisição
    extract_body(conn.body_params)
    |> Tuple.to_list()
    |> case do
      [:ok | rest] ->
        conn
        |> put_status(200)
        |> json(%{code: "200", data: rest})

      [:error, reason] ->
        conn
        |> put_status(422)
        |> json(%{reason: reason})
    end
  end

  defp extract_body(body_params) do
    try do
      %{
        "id" => id,
        "store_id" => store_id,
        "date_created" => date_created,
        "total_amount" => total_amount,
        "total_shipping" => total_shipping,
        "total_amount_with_shipping" => total_amount_with_shipping,
        "order_items" => order_items,
        "payments" => payments,
        "shipping" => shipping,
        "buyer" => buyer
      } = body_params

      IO.inspect(Kernel.inspect(id))

      {:ok, id, store_id, date_created, total_amount, total_shipping, total_amount_with_shipping,
       order_items, payments, shipping, buyer}
    rescue
      MatchError -> {:error, "MatchError"}
    end
  end

  def show(conn, _params) do
    conn
    |> put_status(200)
    |> json(%{code: "200", reason_given: "None."})
  end
end
