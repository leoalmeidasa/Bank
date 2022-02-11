class Account < ApplicationRecord
  belongs_to :user
  has_many :transactions

  validates :account_number, presence: true, uniqueness: true
  validates :balance, presence: true, numericality: true

  validates_numericality_of :balance, greater_than_or_equal_to: 0

  before_validation :generate_number

  private

  def generate_number
    self.account_number = "%05d" % self.user.id if self.user
  end
end
