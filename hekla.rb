require_relative "models/article"

helpers do
  include Hekla::Helpers
end

error Sequel::ValidationFailed do
  [422, @article.errors.flatten.to_json]
end

get "/" do
  Hekla.log :get_articles_index, pjax: pjax?
  cache do
    @articles = Article.ordered.limit(10)
    slim :index, layout: !pjax?
  end
end

get "/articles.atom" do
  Hekla.log :get_articles_index, pjax: pjax?, format: "atom"
  cache do
    @articles = Article.ordered.limit(20)
    builder :articles
  end
end

get "/archive" do
  Hekla.log :get_articles_archive, pjax: pjax?
  cache do
    @articles = Article.ordered.group_by { |a| a.published_at.year }
      .sort.reverse
    @title = "Archive"
    slim :archive, layout: !pjax?
  end
end

get "/:id" do |id|
  Hekla.log :get_article, pjax: pjax?, id: id
  cache do
    @article = Article.find_by_slug!(id)
    @title = @article.title
    slim :show, layout: !pjax?
  end
end

# redirect old style permalinks
get "/articles/:id" do |id|
  Hekla.log :get_article, pjax: pjax?, id: id, old_permalink: true
  redirect to("/#{id}")
end

post "/articles" do
  Hekla.log :create_article
  authorized!
  @article = Article.new(article_params)
  @article.save
  cache_clear
  [201, @article.to_json]
end

put "/articles/:id" do |id|
  Hekla.log :update_article, id: id
  authorized!
  @article = Article.find_by_slug!(id)
  @article.update(article_params)
  cache_clear
  204
end

delete "/articles/:id" do |id|
  Hekla.log :destroy_article, id: id
  authorized!
  @article = Article.find_by_slug!(id)
  @article.destroy
  cache_clear
  204
end
