# frozen_string_literal: true

class TransactionsController < ApplicationController
  before_action :set_transaction, only: %i[show edit update destroy]
  before_action :authenticate_user!
  layout 'index'

  # GET /transactions or /transactions.json
  def index
    @transactions = Transaction.all
  end

  # GET /transactions/1 or /transactions/1.json
  def show; end

  # GET /transactions/new
  def new
    @transaction = Transaction.new
  end

  # GET /transactions/1/edit
  def edit; end

  # POST /transactions or /transactions.json
  def create
    @transaction = Transaction.new(transaction_params)
    @transaction.date_transaction = Time.now

    case @transaction.transaction_type
    when 'Saque'
      @account = Account.where(id: @transaction.account_id).first
      if @account.balance - @transaction.amount < 0.00
        redirect_to new_transaction_path, notice: 'Saldo insuficiente !'
      else
        @account.update!(balance: @account.balance - @transaction.amount)
        @transaction.save
        redirect_to site_index_path, notice: 'Saque realizado !'
      end
    when 'Déposito'
      @account = Account.where(id: @transaction.account_id).first
      @account.update!(balance: @account.balance + @transaction.amount)
      @transaction.save
      redirect_to site_index_path, notice: 'Déposito realizado !'
    when 'Transferência'
      @account = Account.where(id: @transaction.account_id).first
      @account2 = Account.where(account_number: @transaction.account_number).first
      if @account.balance - @transaction.amount > 0.00 && @account2.present?
        set_transference_service
        respond_to do |format|
          if @transference_service.call?
            @transaction.save
            format.html { redirect_to root_path, notice: 'Transference was successfully executed.' }
          end
        end
      else
        respond_to do |format|
          format.html { redirect_to transference_new_path, notice: 'There was an error with your transference.' }
        end
      end
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

  # PATCH/PUT /transactions/1 or /transactions/1.json
  def update
    respond_to do |format|
      if @transaction.update(transaction_params)
        format.html { redirect_to transaction_url(@transaction), notice: 'Transaction was successfully updated.' }
        format.json { render :show, status: :ok, location: @transaction }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /transactions/1 or /transactions/1.json
  def destroy
    @transaction.destroy
    respond_to do |format|
      format.html { redirect_to transactions_url, notice: 'Transaction was successfully destroyed.' }
      format.json { head :no_content }
    end
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
