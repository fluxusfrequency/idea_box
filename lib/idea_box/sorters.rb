module Sorters
  def sort_portfolio_by_rank(portfolio_id)
    find_all_by_portfolio_id(portfolio_id).sort_by(&:rank).reverse
  end

  def sort_by_portfolio_id(portfolio_id)
    find_all_by_portfolio_id(portfolio_id).sort_by(&:id)
  end

  def sort_all_by_tags
    sorted = Hash.new([])
    all_tags.flatten.uniq.each do |tag|
      all.each do |idea|
        sorted[tag] += Array(idea) if idea.tags.include?(tag)
      end
    end
    sorted
  end
end