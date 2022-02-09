json.extract! account, :id, :balance, :account_number, :enabled, :user_id, :created_at, :updated_at
json.url account_url(account, format: :json)
