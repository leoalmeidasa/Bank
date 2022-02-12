# frozen_string_literal: true

class TransferenceController < ApplicationController
  before_action :set_transaction, only: %i[ update ]
  before_action :authenticate_user!
  layout 'index'


  def index

    params[:q] ||= {}
    if params[:q][:created_at_lteq].present?
      params[:q][:created_at_lteq] = params[:q][:created_at_lteq].to_date.end_of_day
    end
    @q = Transaction.ransack(params[:q])
    @transactions = []
    @transactions = @q.result.where(account_id: current_user.id).includes(:account)

  end

  def new
    @transaction = Transaction.new
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_transaction
    @transaction = Transaction.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def transaction_params
    params.require(:transaction).permit(:amount, :transaction_type, :account_number, :date_transaction, :account_id)
  end
end
