class StoreController < ApplicationController
  def index
    @products = Product.order(:title)
    @counter
  end
end
