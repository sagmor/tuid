require 'spec_helper'

describe TUID do
  describe "#initialize" do
    it "generates a random TUID by default" do
      tuid = TUID.new

      expect(tuid).not_to be_nil
    end

    it "accepts a Time object" do
      time = Time.now
      tuid1 = TUID.new(time)
      tuid2 = TUID.new(time)

      expect(tuid1).not_to eql(tuid2)
    end

    it "accepts a UUID formated string" do

    end
  end

  describe "#to_s" do
    it "returns a UUID formated string" do
      tuid = TUID.new

      expect(tuid.to_s).to match(/[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/)
    end
  end

  describe "#<=>" do
  end

  describe "#time" do
    it "returns the time asociated to the TUID" do
      time = Time.now

      tuid = TUID.new(time)

      expect(tuid.time.to_i).to eql(time.to_i)
    end
  end

  describe ""


  it "" do
  end
end
