# A second plain-Ruby model so a PR touches more than one file — the report
# then overlays values across both cart.rb and coupon.rb (merged from the two
# test steps). Branchy on purpose, with varied value types.
class Coupon
  KINDS = %w[percent fixed free_shipping].freeze

  def initialize(code, kind, value = 0)
    @code = code
    @kind = kind
    @value = value
  end

  def percent?
    @kind == "percent"
  end

  # Amount discounted off a given subtotal (never below zero).
  def discount_for(subtotal)
    raw = case @kind
          when "percent" then (subtotal * @value / 100.0).round
          when "fixed"   then @value
          else 0
          end
    [raw, subtotal].min
  end

  def free_shipping?
    @kind == "free_shipping"
  end

  def label
    percent? ? "#{@value}% off" : "#{@code} (#{@kind})"
  end
end
