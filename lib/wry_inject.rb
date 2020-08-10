module WryInject
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def class_with(args)
      args = (@default_args || {}).merge(args)
      namespace = @namespace

      Class.new(self) do
        private

        if namespace
          struct = Struct.new(*args.keys).new(*args.values)
          define_method namespace do
            struct
          end
        else
          args.each do |k, v|
            define_method k do
              v
            end
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

    def wry_namespace(namespace)
      @namespace = namespace
    end
  end
end
