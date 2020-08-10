Wry Inject allows dependency injection without taking control of the `initialize` method.

## Usage

include `WryInject` in your class to add a `class_with` class method. This can be used to inject dependencies into your class and returns a new child class.

```
require 'wry_inject'

class Order
  include WryInject

  def initialize(items)
    @items = items
  end

  def total
    @items.sum { |item| pricing_repo.price_for(item) }
  end
end

klass = Order.class_with(pricing_repo: PricingRepo.new)
klass.new([item1, item2]).total
```
