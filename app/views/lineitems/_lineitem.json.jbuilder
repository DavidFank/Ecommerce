json.extract! lineitem, :id, :product_id, :quantity, :line_item_total, :order_id, :created_at, :updated_at
json.url lineitem_url(lineitem, format: :json)