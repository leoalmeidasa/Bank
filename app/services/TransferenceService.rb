# frozen_string_literal: true

class TransferenceService
  attr_reader :value, :recipient, :sender

  def initialize(value:, recipient:, sender:)
    @value = value
    @recipient = recipient
    @sender = sender
  end

  def call?
    ActiveRecord::Base.transaction do
      remove_from_sender
      add_to_recipient
      transaction_params
    rescue ActiveRecord::RecordInvalid
      true
    end
  end

  private

  def transaction_params
    Transaction.create!(
      amount: @value,
      account_number: @recipient,
      account_id: @sender,
      transaction_type: 'Transferência'
    )
  end

  def remove_from_sender
    @sender.update!(balance: new_balance_sender)
  end

  def add_to_recipient
    @recipient.update!(balance: new_balance_recipient)
  end

  def new_balance_sender
    @sender.balance - (@value.to_f + calcule_transfer_rate + calculate_rate_over_thousand)
  end

  def new_balance_recipient
    @recipient.balance + @value.to_f
  end

  def calcule_transfer_rate
    its_not_working_day_time? ? 7 : 5
  end

  def calculate_rate_over_thousand
    @value.to_f > 1000 ? 10 : 0
  end

  def its_not_working_day_time?
    current_time = Time.now.strftime('%H%M')
    current_day = Time.now.strftime('%u')

    current_day.between?('6', '7') || !current_time.between?('0900', '1800')
  end
end
