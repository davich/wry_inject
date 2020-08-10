module WryInject
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def class_with(args)
      default_args = @default_args || {}
      Class.new(self) do
        (default_args.merge(args)).each do |k, v|
          define_method k do
            v
          end
        end
      end
    end

    def class_with_defaults
      class_with({})
    end

    def wry_defaults(args)
      @default_args = args
    end
  end
end
