module WryInject
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def class_with(**args)
      Class.new(self) do
        args.each do |k, v|
          define_method k do
            v
          end
        end
      end
    end
  end
end
