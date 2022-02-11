# frozen_string_literal: true

class TransactionsController < ApplicationController
  before_action :set_transaction, only: %i[show edit update destroy]
  before_action :authenticate_user!
  layout 'index'

  # GET /transactions or /transactions.json
  def index
    params[:q] ||= {}
    if params[:q][:created_at_lteq].present?
      params[:q][:created_at_lteq] = params[:q][:created_at_lteq].to_date.end_of_day
    end
    @q = Transaction.ransack(params[:q])
    @transactions = []
    @transactions = @q.result.where(account_id: current_user.id).includes(:account)
  end

  # GET /transactions/new
  def new
    @transaction = Transaction.new
  end

  # POST /transactions or /transactions.json
  def create
    @transaction = Transaction.new(transaction_params)
    @transaction.date_transaction = Time.now

    case @transaction.transaction_type
    when 'Saque'
      set_account
      if @account.balance - @transaction.amount < 0.00
        redirect_to new_transaction_path, notice: 'Saldo insuficiente !'
      else
        @account.update(balance: @account.balance - @transaction.amount)
        @transaction.save
        redirect_to site_index_path, notice: 'Saque realizado !'
      end
    when 'Déposito'
      set_account
      @account.update(balance: @account.balance + @transaction.amount)
      @transaction.save
      redirect_to site_index_path, notice: 'Déposito realizado !'
    when 'Transferência'
      set_account
      @account2 = Account.where(account_number: @transaction.account_number).first
      if @account.balance - @transaction.amount > 0.00 && @account2.present?
        set_transference_service
        if @transference_service.call?
          @transaction.save
          respond_to do |format|
            format.html { redirect_to root_path, notice: 'Transferência realizada com sucesso !' }
          end
        end
      else
        respond_to do |format|
          format.html { redirect_to transference_new_path, notice: 'Erro na transferência !' }
        end
      end
    else
      # type code here
    end
  end

  def set_transference_service
    @account = Account.where(id: @transaction.account_id).first
    @account2 = Account.where(account_number: @transaction.account_number).first
    @transference_service = TransferenceService.new(
      value: transaction_params[:amount],
      sender: @account,
      recipient: @account2
    )
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_transaction
    @transaction = Transaction.find(params[:id])
  end

  def set_account
    @account = Account.where(id: @transaction.account_id).first
  end

  # Only allow a list of trusted parameters through.
  def transaction_params
    params.require(:transaction).permit(:amount, :transaction_type, :account_number, :date_transaction, :account_id)
  end
end
