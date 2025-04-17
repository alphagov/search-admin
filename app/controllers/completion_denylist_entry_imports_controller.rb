class CompletionDenylistEntryImportsController < ApplicationController
  def new
    @completion_denylist_entry_import = CompletionDenylistEntryImport.new
  end

  def create
    @completion_denylist_entry_import = CompletionDenylistEntryImport.new(completion_denylist_entry_import_params)

    if @completion_denylist_entry_import.save
      redirect_to(
        completion_denylist_entries_path(category: @completion_denylist_entry_import.category),
        notice: t(".success", count: @completion_denylist_entry_import.records.size),
      )
    else
      render :new
    end
  end

private

  def completion_denylist_entry_import_params
    params.expect(completion_denylist_entry_import: %i[category denylist_csv_data])
  end
end
