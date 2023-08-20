class DepartmentLedgerPopulator
  def on_money_transferd(credit_line:, debit_line:, transfer:)
    return unless contains_user_account?(credit_line)

    department_account = DoubleEntry.account(:department_account, credit_line.detail.department_id)

    from = transfer[:options][:from]
    to = transfer[:options][:to]
    amount = transfer[:amount]

    if user_account?(from)
      DoubleEntry.transfer(amount, from:, to: department_account, code: :department_transaction, metadata: { original_txn: transfer })
    else
      DoubleEntry.transfer(amount, from: department_account, to:, code: :department_transaction, metadata: { original_txn: transfer })
    end
  end

  private

  def contains_user_account?(line)
    user_account?(line.account) || user_account?(line.partner_account)
  end

  def user_account?(account)
    account.identifier == :user_accounts
  end
end
