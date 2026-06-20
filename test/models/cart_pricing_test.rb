require "test_helper"

# A second test file so the workflow can run it in a SEPARATE step from
# cart_test.rb — exercising the top discount tier and the `total` breakdown.
# lumitrace merges the traces from both steps into one report.
class CartPricingTest < ActiveSupport::TestCase
  test "top tier discount on a large cart" do
    cart = Cart.new.add("desk", 12_000) # subtotal 12_000 -> 0.10 tier
    assert_equal 0.10, cart.discount_rate
    assert_equal 1_200, cart.discount
    assert cart.free_shipping?
    assert_equal 0, cart.shipping
  end

  test "total breakdown" do
    cart = Cart.new.add("chair", 8_000) # 0.05 tier
    assert_equal 400, cart.discount
    assert_equal 760, cart.tax          # (8000-400)*0.10
    assert_equal 8_360, cart.total      # 7600 + 760 + 0
  end
end
