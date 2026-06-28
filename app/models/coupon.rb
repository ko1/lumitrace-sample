# A percentage-off coupon, applied to the cart's post-discount amount.
# Lives in its own file so a PR touching cart + coupon shows lumitrace
# tracing across multiple changed files.
class Coupon
  def initialize(code, percent_off)
    @code = code
    @percent_off = percent_off
  end

  def discount_for(amount)
    return 0 if amount <= 0
    (amount * @percent_off / 100.0).round
  end

  # Whether this is a big-ticket coupon. Untested here, so it shows up as an
  # uncovered changed line in the PR check.
  def luxury?
    @percent_off >= 50
  end
end
