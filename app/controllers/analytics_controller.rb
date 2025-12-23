class AnalyticsController < ApplicationController
  def index
    @total_items = current_user.stocks.sum(:quantity)
    @total_value = current_user.stocks.sum('quantity * price')
    @total_value = current_user.stocks.sum('quantity * price')

    grouped = current_user.stocks.group(:category).sum(:quantity).sort_by { |_, v| -v }
    @top_categories_data = grouped.map do |category, count|
      percent = @total_items > 0 ? ((count.to_f / @total_items) * 100).round : 0
      { name: category, count: count, percent: percent }
    end


    stocks = current_user.stocks.order(created_at: :asc).last(10)
    if stocks.size < 2
       @trend_data = [
         { value: 10, label: "Started", date: Date.today - 6 },
         { value: 15, label: "Initial", date: Date.today - 5 },
         { value: 8,  label: "Import",  date: Date.today - 4 },
         { value: 20, label: "Stock",   date: Date.today - 3 },
         { value: 12, label: "Audit",   date: Date.today - 2 },
         { value: 25, label: "Peak",    date: Date.today - 1 },
         { value: 18, label: "Current", date: Date.today }
       ]
    else
       @trend_data = stocks.map do |s| 
         { value: s.quantity, label: s.category, date: s.created_at.to_date } 
       end
    end
  end
end
