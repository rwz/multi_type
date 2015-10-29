module MultiType
  class Group
    attr_reader :klasses
    alias_method :to_a, :klasses

    def initialize(klasses)
      @klasses = klasses.uniq
    end

    def ===(other)
      klasses.any? { |k| k === other }
    end

    def inspect
      ?< + klasses.map(&:inspect) * ", " + ?>
    end

    def to_module
      group = self

      Module.new do
        extend self

        %i[inspect to_a ===].each do |m|
          define_method m do |*args|
            group.public_send m, *args
          end
        end

        def add(*other)
          MultiType[*self, *other]
        end
      end
    end
  end
end
