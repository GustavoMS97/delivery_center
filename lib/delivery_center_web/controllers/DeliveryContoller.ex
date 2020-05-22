defmodule DeliveryCenterWeb.DeliveryController do
  use DeliveryCenterWeb, :controller
  alias DeliveryCenterWeb.Order
  alias DeliveryCenterWeb.Payment
  alias DeliveryCenterWeb.Item
  alias DeliveryCenterWeb.Customer

  def index(conn, _params) do
    conn
    |> put_status(200)
    |> json(%{code: "200"})
  end

  def teste(conn, _params) do
    conn
    |> put_status(200)
    |> json(%{res: conn.body_params})
  end

  def create(conn, _params) do
    try do
      # Extrair dados do corpo da requisição
      extracted_body = extract_body(conn.body_params)
      formatted_items = format_items(extracted_body.order_items)
      formatted_payments = format_payments(extracted_body.payments)
      formatted_shipping = format_shipping(extracted_body.receiver_address)
      formatted_buyer = format_buyer(extracted_body.buyer, formatted_shipping)

      order =
        build_order(%{extracted_body: extracted_body, formatted_shipping: formatted_shipping})

      # Salvar dados no banco.
      save_data(order, formatted_buyer, formatted_items, formatted_payments)
      # Criar objeto do corpo esperado pela requisição
      dc_req =
        Map.merge(
          %{
            customer: formatted_buyer,
            items: formatted_items,
            payments: formatted_payments
          },
          order
        )

      {:ok, res} = JSON.Encoder.encode(dc_req)

      IO.inspect(res)

      %HTTPoison.Response{body: body, status_code: status_code} =
        HTTPoison.post!("https://delivery-center-recruitment-ap.herokuapp.com", res, [
          {"Content-Type", "application/json"}
        ])

      IO.inspect(body)

      case status_code do
        200 ->
          conn
          |> put_status(200)
          |> json(dc_req)

        _ ->
          raise "Delivery Center server refused to accept the sent data."
      end
    rescue
      MatchError ->
        conn
        |> put_status(422)
        |> json(%{reason: "Error parsing data"})

      e ->
        conn
        |> put_status(500)
        |> json(%{reason: e.message || "Internal error"})
    end
  end

  defp save_data(order, customer, items, payments) do
    order_changeset = Order.changeset(%Order{}, order)

    # persistir pedido
    case Repo.insert(order_changeset) do
      {:ok, %Order{id: id}} ->
        # Persistir pagamentos
        Enum.each(payments, fn payment ->
          payment_changeset = Payment.changeset(%Payment{}, Map.merge(payment, %{order_id: id}))
          Repo.insert!(payment_changeset)
        end)

        # Persistir itens
        Enum.each(items, fn item ->
          item_changeset = Item.changeset(%Item{}, Map.merge(item, %{order_id: id}))
          Repo.insert!(item_changeset)
        end)

        # Persistir cliente
        customer_changeset = Customer.changeset(%Customer{}, Map.merge(customer, %{order_id: id}))

        Repo.insert!(customer_changeset)

      # Something went wrong
      {:error, _changeset} ->
        raise "Error order data into the database"
    end
  end

  defp build_order(%{
         extracted_body: extracted_body,
         formatted_shipping: formatted_shipping
       }) do
    %{
      externalCode: Kernel.inspect(extracted_body.id),
      storeId: extracted_body.store_id,
      subTotal: Kernel.inspect(extracted_body.total_amount),
      deliveryFee: Kernel.inspect(extracted_body.total_shipping),
      total: Kernel.inspect(extracted_body.total_amount_with_shipping),
      dtOrderCreate: extracted_body.date_created,
      country: formatted_shipping.country_id,
      state: formatted_shipping.state_name,
      city: formatted_shipping.city_name,
      district: formatted_shipping.neighborhood_name,
      street: formatted_shipping.state_name,
      complement: formatted_shipping.comment,
      latitude: formatted_shipping.latitude,
      longitude: formatted_shipping.longitude,
      postalCode: formatted_shipping.zip_code,
      number: formatted_shipping.street_number
    }
  end

  defp extract_body(body_params) do
    %{
      "id" => id,
      "store_id" => store_id,
      "date_created" => date_created,
      "total_amount" => total_amount,
      "total_shipping" => total_shipping,
      "total_amount_with_shipping" => total_amount_with_shipping,
      "order_items" => order_items,
      "payments" => payments,
      "shipping" => %{"receiver_address" => receiver_address},
      "buyer" => buyer
    } = body_params

    %{
      id: id,
      store_id: store_id,
      date_created: date_created,
      total_amount: total_amount,
      total_shipping: total_shipping,
      total_amount_with_shipping: total_amount_with_shipping,
      order_items: order_items,
      payments: payments,
      receiver_address: receiver_address,
      buyer: buyer
    }
  end

  defp format_items(order_items) do
    for order_items <- order_items do
      %{
        "item" => %{"id" => id, "title" => title},
        "quantity" => quantity,
        "unit_price" => unit_price
      } = order_items

      %{
        externalCode: id,
        name: title,
        price: unit_price,
        quantity: quantity,
        total: unit_price * quantity
      }
    end
  end

  defp format_payments(payments) do
    for payment <- payments do
      %{"payment_type" => payment_type, "total_paid_amount" => total_paid_amount} = payment
      %{type: payment_type, value: total_paid_amount}
    end
  end

  defp format_shipping(receiver_address) do
    %{
      "street_name" => street_name,
      "street_number" => street_number,
      "comment" => comment,
      "zip_code" => zip_code,
      "city" => %{"name" => city_name},
      "state" => %{"name" => state_name},
      "country" => %{"id" => country_id},
      "neighborhood" => %{"name" => neighborhood_name},
      "latitude" => latitude,
      "longitude" => longitude,
      "receiver_phone" => receiver_phone
    } = receiver_address

    %{
      street_name: street_name,
      street_number: street_number,
      comment: comment,
      zip_code: zip_code,
      city_name: city_name,
      state_name: state_name,
      country_id: country_id,
      neighborhood_name: neighborhood_name,
      latitude: latitude,
      longitude: longitude,
      receiver_phone: receiver_phone
    }
  end

  defp format_buyer(buyer, formatted_shipping) do
    %{"id" => buyer_id, "nickname" => nickname, "email" => email} = buyer

    %{
      externalCode: Kernel.inspect(buyer_id),
      name: nickname,
      email: email,
      contact: formatted_shipping.receiver_phone
    }
  end

  def show(conn, _params) do
    conn
    |> put_status(200)
    |> json(%{code: "200", reason_given: "None."})
  end
end
