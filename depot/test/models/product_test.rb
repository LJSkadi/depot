require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  fixtures :products
  # Is the input valid?
  test 'product attributes must not be empty' do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
    assert product.errors[:image_url].any?
  end
  # Is the price is in the right format?
  test 'value of the product price MUST be POSITIVE' do
    product = Product.new(title:  'My Book Title',
                          description:  'yyy',
                          image_url:    'zzz.jpg')
    product.price = -1
    assert product.invalid?
    assert_equal ['must be greater than or equal to 0.01'],
                 product.errors[:price]

    product.price = 0
    assert product.invalid?
    assert_equal ['must be greater than or equal to 0.01'],
                 product.errors[:price]

    product.price = 1
    assert product.valid?
  end
  # Is the image in the right format?
  def new_product(image_url)
    Product.new(title:  'My Book Title',
                description:  'yyy',
                price:        1,
                image_url:    image_url)
  end

  test 'image_url' do
    ok = %w[ fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg
             http://a.b.c/x/y/z/fred.gif ]
    bad = %w[wfred.doc fred.gif/more fred.gif.more]
    ok.each do |image_url|
      assert new_product(image_url).valid?,
             "#{image_url} shouldn't be invalid"
    end

    bad.each do |image_url|
      assert new_product(image_url).invalid?,
             "#{image_url} shouldn't be valid"
    end
  end
  # Is the title unique?
  test 'product is not valid without a unique title' do
    product = Product.new(title: products(:ruby).title,
                          description:  'yyy',
                          price: 1,
                          image_url:  'fred.gif')

    assert product.invalid?
    assert_equal [I18n.translate('errors.messages.taken')],
                 product.errors[:title]
  end
end
