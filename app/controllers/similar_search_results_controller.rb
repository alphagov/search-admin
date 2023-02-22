class SimilarSearchResultsController < ApplicationController
  def new
    render :new, locals: default_locals
  end

  def show
    base_path = params[:base_path]

    render :show,
           locals: {
             base_path:,
             results: MoreLikeThis.from_base_path(base_path),
           }
  rescue MoreLikeThis::NotFoundInSearch
    render_with_error("Content item not found for #{base_path}")
  rescue MoreLikeThis::NotTaggedToATaxon
    render_with_error("The page #{base_path} isn't tagged to a taxon")
  rescue MoreLikeThis::NoSearchResults
    render_with_error("No search results found for #{base_path}")
  end

private

  def render_with_error(message)
    flash.now[:error] = message

    render(
      :new,
      locals: default_locals,
    )
  end

  def default_locals
    {
      base_path: params[:base_path],
      results: [],
    }
  end
end
