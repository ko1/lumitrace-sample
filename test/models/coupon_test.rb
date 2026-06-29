require "test_helper"

class CouponTest < ActiveSupport::TestCase
  test "percentage discount on the post-discount amount" do
    coupon = Coupon.new("SAVE10", 10)
    assert_equal 570, coupon.discount_for(5_700)  # 5700 * 10%
  end
end
