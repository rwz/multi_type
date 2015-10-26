module MultiType
  class Group
    def initialize(klasses)
      @klasses = klasses
    end

    def ===(other)
      @klasses.any? { |k| k === other }
    end

    def inspect
      ?< + @klasses.map(&:inspect).join(", ") + ?>
    end

    def to_module
      group = self

      Module.new do
        extend self

        %i[inspect ===].each do |m|
          define_method m do |*args|
            group.public_send m, *args
          end
        end
      end
    end
  end
end
