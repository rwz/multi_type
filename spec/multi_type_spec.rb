require "spec_helper"

describe MultiType do
  it "has a version number" do
    expect(described_class::VERSION).to be
  end

  it "builds a group using #[] method" do
    group = double
    mod = double

    allow(group).to receive(:to_module)
      .and_return(mod)

    expect(described_class::Group).to receive(:new)
      .with([String, Numeric])
      .and_return(group)

    expect(described_class[String, Numeric]).to eq(mod)
  end
end
