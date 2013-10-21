module Groupers

  def group_all_by_id
    all.group_by do |idea|
      idea.id
    end
  end

  def group_all_by_time_created
    all.group_by do |idea|
      Time.parse(Time.parse(idea.created_at.to_s, "%Y-%m-%d %H:%I:%S %z").strftime("%l:%M%p"))
    end

  end

  def group_all_by_day_created
    all.group_by do |idea|
      new_date = Date.parse(idea.created_at) unless idea.created_at.class == Time
      new_date.strftime "%a" if new_date
    end
  end

  def group_all_by_portfolio_id
    all_ideas.group_by do |idea|
      idea.portfolio_id
    end
  end

end
