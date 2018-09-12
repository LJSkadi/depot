class Product < ApplicationRecord
  has_many :line_items

  before_destroy :ensure_not_referenced_by_any_line_item

  validates :title, :description, :image_url, :price, presence: true
  validates :title, uniqueness: true, length: { minimum: 10 }
  validates :image_url, allow_blank: true, format: {
    with:   /\.(gif|jpg|png)\Z/i,
    message: 'must be a URL or GIF, JPG or PNG image'
  }
  validates :price, numericality: { greater_than_or_equal_to: 0.01 }

  private

  # ensure that there are no line items referencing to this product
  # This is a hook method. Rails calls this method automatically at a given
  # point in an object's life. This hook method is called before Rails attempts
  # to destroy a row in the database. If the hook method throws :abort, the row
  # isn't destroyed
  def ensure_not_referenced_by_any_line_item
    unless line_items.empty?
      errors.add(:base, 'Line Items present')
      throw :abort
    end
  end
end
