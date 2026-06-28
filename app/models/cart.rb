# A plain-Ruby domain model (autoloaded by Rails from app/models).
# Deliberately full of small branches and varied value types so lumitrace has
# something interesting to show on a PR: integers, floats, booleans, arrays.
class Cart
  FREE_SHIPPING_THRESHOLD = 4_000
  TAX_RATE = 0.10

  Item = Struct.new(:name, :price, :qty) do
    def amount
      price * qty
    end
  end

  def initialize(items = [])
    @items = items
  end

  def add(name, price, qty = 1)
    @items << Item.new(name, price, qty)
    self
  end

  def subtotal
    @items.sum(&:amount)
  end

  # Tiered discount rate based on subtotal.
  def discount_rate
    case subtotal
    when 0...3_000 then 0.0
    when 3_000...10_000 then 0.05
    else 0.10
    end
  end

  def discount
    (subtotal * discount_rate).round
  end

  def shipping
    free_shipping? ? 0 : 500
  end

  def free_shipping?
    subtotal - discount >= FREE_SHIPPING_THRESHOLD
  end

  def tax
    ((subtotal - discount) * TAX_RATE).round
  end

  def total
    subtotal - discount + tax + shipping
  end

  def summary
    {
      items: @items.size,
      subtotal: subtotal,
      discount: discount,
      free_shipping: free_shipping?,
      total: total
    }
  end

  # Loyalty points: 1 point per ¥100 of the final total.
  def points
    total / 100
  end

  # Apply a percentage coupon on top of the tier discount.
  def apply_coupon(coupon)
    coupon.discount_for(subtotal - discount)
  end

  # Rough delivery estimate from the total item count. Not exercised by the
  # tests in this PR, so lumitrace flags these as uncovered changed lines.
  def estimated_delivery_days
    units = @items.sum(&:qty)
    case units
    when 0..2 then 1
    when 3..9 then 2
    else 4
    end
  end
end
