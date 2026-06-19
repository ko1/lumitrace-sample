require "test_helper"

class CartTest < ActiveSupport::TestCase
  test "no discount below the first tier" do
    cart = Cart.new.add("pen", 200, 3) # subtotal 600
    assert_equal 0.0, cart.discount_rate
    assert_equal 600, cart.subtotal
    assert_equal 0, cart.discount
    assert_equal 500, cart.shipping
    refute cart.free_shipping?
  end

  test "mid tier discount and tax" do
    cart = Cart.new.add("book", 1_500, 4) # subtotal 6_000
    assert_equal 0.05, cart.discount_rate
    assert_equal 300, cart.discount        # 6000 * 0.05
    assert cart.free_shipping?             # 5700 >= 5000
    assert_equal 0, cart.shipping
    assert_equal 570, cart.tax             # (6000-300)*0.10
    assert_equal 6_270, cart.total
  end

  test "summary shape" do
    cart = Cart.new.add("a", 1_000).add("b", 2_000, 2)
    summary = cart.summary
    assert_equal 2, summary[:items]
    assert_equal 5_000, summary[:subtotal]
    assert_includes [true, false], summary[:free_shipping]
  end
end
