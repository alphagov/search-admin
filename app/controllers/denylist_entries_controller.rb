class DenylistEntriesController < ApplicationController
  before_action :set_denylist_entry, only: %i[edit update destroy]

  self.primary_navigation_area = :autocomplete
  self.secondary_navigation_area = :denylist_entries
  layout "autocomplete"

  def index
    @denylist_entries = DenylistEntry
      .where(category: category_filter)
      .order(:phrase)
    @category_filter = category_filter
    @total_count = DenylistEntry.count
  end

  def new
    @denylist_entry = DenylistEntry.new
  end

  def create
    @denylist_entry = DenylistEntry.new(denylist_entry_params)

    if @denylist_entry.save
      redirect_to denylist_entries_path(category: @denylist_entry.category), notice: t(".success")
    else
      render :new
    end
  end

  def edit; end

  def update
    @denylist_entry.assign_attributes(denylist_entry_params)

    if @denylist_entry.save
      redirect_to denylist_entries_path(category: @denylist_entry.category), notice: t(".success")
    else
      render :edit
    end
  end

  def destroy
    if @denylist_entry.destroy
      redirect_to denylist_entries_path(category: @denylist_entry.category), notice: t(".success")
    else
      redirect_to denylist_entries_path(category: @denylist_entry.category), alert: t(".failure")
    end
  end

private

  def set_denylist_entry
    @denylist_entry = DenylistEntry.find(params[:id])
  end

  def denylist_entry_params
    params.expect(denylist_entry: %i[phrase comment match_type category])
  end

  def category_filter
    DenylistEntry.categories.keys.find { it == params[:category] } ||
      DenylistEntry.categories.keys.first
  end
end
