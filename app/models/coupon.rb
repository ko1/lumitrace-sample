# A second model so the report overlays values across more than one file.
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

  # Not exercised by tests — an uncovered line in this file.
  def label
    percent? ? "#{@value}% off" : "#{@code} (#{@kind})"
  end
end
