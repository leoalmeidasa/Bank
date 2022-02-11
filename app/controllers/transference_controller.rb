class TransferenceController < ApplicationController
  before_action :set_transaction, only: %i[show edit update destroy]
  before_action :authenticate_user!
  layout 'index'
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
