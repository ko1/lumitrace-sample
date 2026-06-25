require "test_helper"

class CouponTest < ActiveSupport::TestCase
  test "percent coupon discounts a subtotal" do
    c = Coupon.new("SAVE20", "percent", 20)
    assert c.percent?
    assert_equal 1_000, c.discount_for(5_000)
  end

  test "fixed coupon is capped at the subtotal" do
    c = Coupon.new("MINUS500", "fixed", 500)
    assert_equal 500, c.discount_for(5_000)
    assert_equal 300, c.discount_for(300)
  end
  # note: #label is intentionally not tested -> shows as uncovered
end
