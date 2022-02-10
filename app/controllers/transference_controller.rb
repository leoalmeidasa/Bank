class TransferenceController < ApplicationController
  before_action :set_transaction, only: %i[show edit update destroy]
  before_action :authenticate_user!
  layout 'index'
  def new
    @transaction = Transaction.new
  end


  # POST /transactions or /transactions.json
  def create
    @transaction = Transaction.new(transaction_params)
    @transaction.date_transaction = Time.now

    case @transaction.transaction_type
    when 'Transferência'
      set_transference_service
      respond_to do |format|
        if @transference_service.call?
          format.html { redirect_to root_path, notice: "Transference was successfully executed." }
        else
          format.html { redirect_to new_transaction_path, notice: "There was an error with your transference." }
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to new_transaction_path, notice: "Incorrect password" }
      end
    end
  end

  def set_transference_service
    @transference_service = Transaction.new(
      amount: transaction_params[:amount],
      recipient: transaction_params[:account_number],
      sender: Account.where(id: @transaction.account_id).first
      )
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
