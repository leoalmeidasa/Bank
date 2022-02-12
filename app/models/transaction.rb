class Transaction < ApplicationRecord
  belongs_to :account

  validates :amount, presence: true, numericality: true
  validates :transaction_type, presence: true
  validates_numericality_of :amount, greater_than_or_equal_to: 0
end
