require "spec_helper"

RSpec.describe Tealeaves::AppGenerator do
  it "includes ExitOnFailure" do
    expect(described_class.ancestors).to include(Tealeaves::ExitOnFailure)
  end
end
