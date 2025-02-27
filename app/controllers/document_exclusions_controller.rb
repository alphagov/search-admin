class DocumentExclusionsController < ApplicationController
  before_action :set_document_exclusion, only: %i[show edit update destroy]

  self.primary_navigation_area = :search
  self.secondary_navigation_area = :document_exclusions
  layout "search"

  def index
    @document_exclusions = DocumentExclusion.all
  end

  def new
    @document_exclusion = DocumentExclusion.new
  end

  def create
    @document_exclusion = DocumentExclusion.new(document_exclusion_params)

    if @document_exclusion.save
      redirect_to @document_exclusion, notice: t(".success")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show; end

  def edit; end

  def update
    @document_exclusion.assign_attributes(document_exclusion_params)

    if @document_exclusion.save
      redirect_to @document_exclusion, notice: t(".success")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @document_exclusion.destroy
      redirect_to document_exclusions_path, notice: t(".success")
    else
      redirect_to @document_exclusion, alert: t(".failure")
    end
  end

private

  def set_document_exclusion
    @document_exclusion = DocumentExclusion.find(params[:id])
  end

  def document_exclusion_params
    params.expect(document_exclusion: %i[link comment])
  end
end
