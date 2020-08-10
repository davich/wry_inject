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
    @items.sum { |item| pricing_repo.price_for(item) }
  end
end

klass = Order.class_with(pricing_repo: PricingRepo.new)
klass.new([item1, item2]).total
```

You can also have default values, as seen below

```
class MyClassWithDefaults
  include WryInject

  wry_defaults amount: 3, units: 7

  def total
    units * amount
  end
end

MyClassWithDefaults.class_with_defaults.new.total
MyClassWithDefaults.class_with(amount: 4).new.total
```

You can also add a namespace so the injected variables don't get lost in all your other methods:

```
class MyClassWithNamespace
  include WryInject
  wry_namespace :wry
  wry_defaults amount: 5, units: 7

  def total
    wry.units * wry.amount
  end
end

MyClassWithNamespace.class_with(amount: 4).new.total
MyClassWithNamespace.class_with_defaults.new.total
```
