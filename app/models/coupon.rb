# A percentage-off coupon. Traced by the `coupon` shard only — so without the
# merge step it would look uncovered in the `cart` shard's report.
class Coupon
  def initialize(code, percent_off)
    @code = code
    @percent_off = percent_off
  end

  def discount_for(amount)
    return 0 if amount <= 0
    (amount * @percent_off / 100.0).round
  end

  # Untested → uncovered changed line even after merge.
  def luxury?
    @percent_off >= 50
  end
end
