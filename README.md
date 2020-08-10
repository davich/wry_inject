Wry Inject allows dependency injection without taking over the `initialize` method.

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
    @items.sum { |item| pricing_service.price_for(item) }
  end
end

klass = Order.class_with(pricing_service: PricingService.new)
klass.new([item1, item2]).total
```

You can also have default values, as seen below

```
class Order
  include WryInject

  wry_defaults pricing_service: PricingService.new, logger: Logger.new

  def initialize(items)
    @items = items
  end

  def total
    logger.log("retrieving total")
    @items.sum { |item| pricing_service.price_for(item) }
  end
end

Order.class_with_defaults.new([item1]).total
Order.class_with(pricing_service: MockPricingService.new).new([item1]).total
```

You can also add a namespace so the injected variables don't get lost in all your other methods:

```
class Order
  include WryInject
  wry_namespace :wry
  wry_defaults pricing_service: PricingService.new, logger: Logger.new

  def initialize(items)
    @items = items
  end

  def total
    wry.logger.log("retrieving total")
    @items.sum { |item| wry.pricing_service.price_for(item) }
  end
end

Order.class_with_defaults.new([item1]).total
Order.class_with(pricing_service: MockPricingService.new).new([item1]).total
```
