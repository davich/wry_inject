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
end
