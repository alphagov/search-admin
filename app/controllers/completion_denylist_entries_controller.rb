class CompletionDenylistEntriesController < ApplicationController
  before_action :set_completion_denylist_entry, only: %i[edit update destroy]

  self.primary_navigation_area = :autocomplete
  self.secondary_navigation_area = :completion_denylist_entries
  layout "autocomplete"

  def index
    @completion_denylist_entries = CompletionDenylistEntry
      .where(category: category_filter)
      .order(:phrase)
    @category_filter = category_filter
    @total_count = CompletionDenylistEntry.count
  end

  def new
    @completion_denylist_entry = CompletionDenylistEntry.new
  end

  def create
    @completion_denylist_entry = CompletionDenylistEntry.new(completion_denylist_entry_params)

    if @completion_denylist_entry.save
      redirect_to completion_denylist_entries_path(category: @completion_denylist_entry.category), notice: t(".success")
    else
      render :new
    end
  end

  def edit; end

  def update
    @completion_denylist_entry.assign_attributes(completion_denylist_entry_params)

    if @completion_denylist_entry.save
      redirect_to completion_denylist_entries_path(category: @completion_denylist_entry.category), notice: t(".success")
    else
      render :edit
    end
  end

  def destroy
    if @completion_denylist_entry.destroy
      redirect_to completion_denylist_entries_path(category: @completion_denylist_entry.category), notice: t(".success")
    else
      redirect_to completion_denylist_entries_path(category: @completion_denylist_entry.category), alert: t(".failure")
    end
  end

private

  def set_completion_denylist_entry
    @completion_denylist_entry = CompletionDenylistEntry.find(params[:id])
  end

  def completion_denylist_entry_params
    params.expect(completion_denylist_entry: %i[phrase comment match_type category])
  end

  def category_filter
    CompletionDenylistEntry.categories.keys.find { it == params[:category] } ||
      CompletionDenylistEntry.categories.keys.first
  end
end
