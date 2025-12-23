class StocksController < ApplicationController
  before_action :set_stock, only: [ :show, :edit, :update, :destroy ]
  before_action :require_login

  def index
    @categories = current_user.stocks.distinct.pluck(:category).compact_blank

    all_stocks = current_user.stocks
    @total_value = all_stocks.sum("price * quantity").to_i
    @total_items = all_stocks.sum(:quantity)
    @total_categories = @categories.size

    if params[:category].present?
      @stocks = all_stocks.where(category: params[:category])
    elsif params[:filter] == 'low_stock'
      @stocks = all_stocks.where("quantity <= ?", 5)
    else
      @stocks = all_stocks
    end

    @stocks_by_category = @stocks.group_by(&:category)
  end


  def show
  end

  def new
    @stock = Stock.new
  end

  def create
      @stock = current_user.stocks.build(stock_params)

    if @stock.save
      redirect_to @stock, notice: "Stock created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @stock.update(stock_params)
      redirect_to @stock, notice: "Stock updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @stock
      @stock.destroy
      redirect_to stocks_path, notice: "Stock deleted successfully."
    end
  end



  private

  def set_stock
    @stock = Stock.find(params[:id])
  end

  def stock_params
    params.require(:stock).permit(:brand, :model, :price, :quantity, :category)
  end
end
