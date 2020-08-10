require 'wry_inject'

class MyClass
  include WryInject

  def initialize(other)
    @other = other
  end

  def total(multiplier)
    units * amount * @other * multiplier
  end

  def add
    units + amount + @other
  end

  def double_amount
    amount * 2
  end
end

class MyClassWithDefaults
  include WryInject

  wry_defaults amount: 3, units: 7

  def total
    units * amount
  end
end

class MyClassWithNamespace
  include WryInject
  wry_namespace :wry
  wry_defaults amount: 5, units: 7

  def total
    wry.units * wry.amount
  end
end

RSpec.describe WryInject do
  subject { MyClass.class_with(amount: 5, units: 6) }

  it "can use injected variables" do
    expect(subject.new(0).double_amount).to eq(10)
  end

  it "can use injected and constructor variables" do
    expect(subject.new(9).add).to eq(20)
  end

  it "can use injected, constructor, and method arg variables" do
    expect(subject.new(9).total(2)).to eq(540)
  end

  it "makes the injected object methods private" do
    expect { subject.new(0).units }.to raise_error(NoMethodError)
    expect { subject.new(0).amount }.to raise_error(NoMethodError)
  end

  context "with defaults" do
    it "handles default values" do
      expect(MyClassWithDefaults.class_with_defaults.new.total).to eq(21)
    end

    it "handles overwriting one default value" do
      expect(MyClassWithDefaults.class_with(amount: 4).new.total).to eq(28)
    end
  end

  context "with namespace" do
    it "handles default values" do
      expect(MyClassWithNamespace.class_with_defaults.new.total).to eq(35)
    end

    it "makes namespace method private" do
      expect { MyClassWithNamespace.class_with_defaults.new.wry }.to raise_error(NoMethodError)
    end
  end
end
