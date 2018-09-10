class Product < ApplicationRecord
  validates :title, :description, :image_url, :price, presence: true
  validates :title, uniqueness: true
  validates :image_url, allow_blank: true, format: {
    with:   /\.(gif|jpg|png)\Z/i,
    message: 'must be a URL or GIF, JPG or PNG image'
  }
  validates :price, numericality: { greater_than_or_equal_to: 0.01 }
end
