class DepartmentLedgerPopulator
  def on_money_transferred(event)
    credit_line = event[:credit_line]
    debit_line = event[:debit_line]
    transfer = event[:transfer]

    return unless contains_user_account?(credit_line)

    department = Department.find(credit_line.detail.department_id)
    department_account = DoubleEntry.account(:department_account, scope: department)

    from = transfer[:options][:from]
    to = transfer[:options][:to]
    amount = transfer[:amount]

    if user_account?(from)
      from = DoubleEntry.account(:user_department_account, scope: from.scope)
      DoubleEntry.transfer(amount, from:, to: department_account, code: :department_transaction, metadata: { original_txn: transfer })
    else
      to = DoubleEntry.account(:user_department_account, scope: to.scope)
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
