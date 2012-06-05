class Article < ActiveRecord::Base
  scope :ordered, order('published_at DESC')
  validates_presence_of :title, :slug, :content, :published_at
  validates_uniqueness_of :slug

  def content_html
    render_markdown(content)
  end

  def summary_html
    render_markdown(summary)
  end

  def to_path
    "/#{slug}"
  end

  private

  def render_markdown(str)
    renderer = Redcarpet::Markdown.new(Redcarpet::Render::HTML, 
      :fenced_code_blocks => true, :hard_wrap => true)

    # Redcarpet now allows a new renderer to be defined. This would be better.
    renderer.render(str).
      gsub /<code class="(\w+)">/, %q|<code class="language-\1">|
  end
end
