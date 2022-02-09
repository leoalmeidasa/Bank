json.extract! transaction, :id, :amount, :transaction_type, :account_number, :date_transaction, :account_id, :created_at, :updated_at
json.url transaction_url(transaction, format: :json)
