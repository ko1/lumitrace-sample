require "test_helper"

# Runs in a SEPARATE workflow step from cart_test.rb and exercises a DIFFERENT
# file (coupon.rb). lumitrace merges the traces from both steps, so the report
# overlays values across both models.
class CouponTest < ActiveSupport::TestCase
  test "percent coupon discounts a subtotal" do
    c = Coupon.new("SAVE20", "percent", 20)
    assert c.percent?
    assert_equal 1_000, c.discount_for(5_000)
    assert_equal "20% off", c.label
  end

  test "fixed coupon never exceeds the subtotal" do
    c = Coupon.new("MINUS500", "fixed", 500)
    assert_equal 500, c.discount_for(5_000)
    assert_equal 300, c.discount_for(300)   # capped at subtotal
  end

  test "free shipping coupon" do
    c = Coupon.new("SHIPFREE", "free_shipping")
    assert c.free_shipping?
    assert_equal 0, c.discount_for(5_000)
  end
end
