require "spec_helper"

describe MultiType::Group do
  it "can be initialized with an array of classes" do
    described_class.new([String, Fixnum])
  end

  describe "as group" do
    it "matches with mentioned types" do
      errors = [ StandardError, ArgumentError ]
      error_type = described_class.new(errors)

      expect(ArgumentError.new).to be_of_type(error_type)
      expect(StandardError.new).to be_of_type(error_type)
    end

    it "does't match with other types" do
      type = described_class.new([String, Symbol])
      expect(123).to_not be_of_type(type)
    end

    it "can be combined with other group" do
      group = described_class.new([StandardError, ArgumentError])
      combined_group = described_class.new([group, SyntaxError])
      [ StandardError, ArgumentError, SyntaxError].each do |klass|
        expect(klass.new).to be_of_type(combined_group)
      end
    end
  end

  describe "as module" do
    def build(*klasses)
      described_class.new(klasses).to_module
    end

    it "can be used for exception rescuing" do
      errors = build(ArgumentError, SyntaxError)

      action = -> do
        begin
          raise ArgumentError, "hello"
        rescue errors
          "world"
        end
      end

      expect(&action).to_not raise_error
    end

    it "can be combined with other type" do
      errors = build(ArgumentError, SyntaxError)
      combined = errors.add(TypeError, NameError)

      [ NameError, TypeError ].each do |klass|
        expect(klass.new).to_not be_of_type(errors)
        expect(klass.new).to be_of_type(combined)
      end
    end

    it "can be combined with other multi type" do
      errors = build(ArgumentError, SyntaxError)
      combined = errors.add(build(TypeError, NameError))

      [ NameError, TypeError ].each do |klass|
        expect(klass.new).to_not be_of_type(errors)
        expect(klass.new).to be_of_type(combined)
      end
    end
  end
end
