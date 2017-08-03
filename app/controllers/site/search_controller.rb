class Site::SearchController < SiteController
  def ads
    @ads = Ad.search(params[:search], params[:page])
    @categories = Category.all
  end
end
