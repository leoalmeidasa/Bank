# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true

  has_one :account

  after_create :create_account

  def active_for_authentication?
    super && account.enabled?
  end

  private

  def create_account
    @ac = Account.new(user: self, balance: 0, enabled: true)
    raise 'Conta do Banco não foi criada' unless @ac.save
  end
end
