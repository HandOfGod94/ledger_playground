Rails.application.reloader.to_prepare do
  Wisper.subscribe(DepartmentLedgerPopulator.new, prefix: :on)
end
