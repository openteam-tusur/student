module MainPageNewsHelper
  def main_page_news_item(item, index)
    content = []
    content << render(partial: 'news/small', locals: { item: item }) if index > 0 && index < 5

    if item.images.size > 4
      content << render(partial: 'news/medium', locals: { item: item }) if index == 5
    else
      content << render(partial: 'news/small', locals: { item: item }) if index >= 5
    end

    content.join.html_safe
  end

  def main_page_interesting(photos, videos)
    [photos, videos].flatten.sort_by(&:since).reverse.take(3)
  end
end
