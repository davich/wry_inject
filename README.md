Wry Inject allows dependency injection without taking over the `initialize` method.

Dependency injection allows us to avoid tight coupling in our projects. Instead of your class referencing a dependency directly (eg. a repository, payment gateway, etc.) these dependencies are passed in by a caller.

This allows tests to use a mock repository so it doesn't hit the db. Or a stubbed payment gateway so the class under test doesn't make calls to external systems. It also allows for much simpler testing (without 'allows_any_instance_of' calls).

This amount of configurability is great! But we want to avoid forcing callers to configure our class before they use it. Most callers will be happy with the default options.

This gem aims to provide dependency injection functionality with the least amount of "getting in the way".

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

You can also add a namespace so the injected variables don't polute the namespace. As you can see in the above examples, dependencies can get lost in all your other methods. This allows more visibility about what the dependencies are.

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
