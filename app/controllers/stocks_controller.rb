class StocksController < ApplicationController
  before_action :set_stock, only: [ :show, :edit, :update, :destroy ]
  before_action :require_login

  def index
    @stocks = Stock.all
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
    params.require(:stock).permit(:brand, :model, :price, :quantity)
  end
end
