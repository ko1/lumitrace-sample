require "test_helper"

class CartTest < ActiveSupport::TestCase
  test "no discount below the first tier" do
    cart = Cart.new.add("pen", 200, 3) # subtotal 600
    assert_equal 0.0, cart.discount_rate
    assert_equal 600, cart.subtotal
    assert_equal 500, cart.shipping
    refute cart.free_shipping?
  end

  test "mid tier discount and tax" do
    cart = Cart.new.add("book", 1_500, 4) # subtotal 6_000
    assert_equal 300, cart.discount
    assert_equal 570, cart.tax
    assert_equal 6_270, cart.total
  end

  test "loyalty points" do
    cart = Cart.new.add("book", 1_500, 4) # total 6_270
    assert_equal 62, cart.points
  end
end
