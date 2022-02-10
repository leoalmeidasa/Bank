class Transaction < ApplicationRecord
  belongs_to :account

  validates :amount, presence: true, numericality: true
end
