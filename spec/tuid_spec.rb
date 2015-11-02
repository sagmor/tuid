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
      string = '5635126f-aec1-c0eb-a23c-388d0cc5de92'

      tuid = TUID.new(string)

      expect(tuid.to_s).to eql(string)
    end

    it "accepts a binary string" do
      tuid1 = TUID.new
      tuid2 = TUID.new(tuid1.bytes.dup)

      expect(tuid2).to eql(tuid1)
    end

    it "accepts another TUID object" do
      tuid1 = TUID.new
      tuid2 = TUID.new(tuid1)

      expect(tuid2).to eql(tuid1)
    end

    it "raises an error when arguments are invalid" do
      expect{ TUID.new([]) }.to raise_error(TypeError)
      expect{ TUID.new("asdf") }.to raise_error(TypeError)
      expect{ TUID.new("123456789012345678901234567890123456") }.to raise_error(TypeError)
    end
  end

  describe "#to_s" do
    it "returns a UUID formated string" do
      tuid = TUID.new

      expect(tuid.to_s).to match(/[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/)
    end
  end

  describe "#<=>" do
    it "Sort's TUIDs by Time" do
      tuid1 = TUID.new(Time.at(0))
      tuid2 = TUID.new(Time.at(1))

      expect(tuid1).to be < tuid2
    end
  end

  describe "#time" do
    it "returns the time asociated to the TUID" do
      time = Time.now

      tuid = TUID.new(time)

      expect(tuid.time.to_i).to eql(time.to_i)
    end
  end

  describe "#inspect" do
    it "describe the TUID object" do
      tuid = TUID.new("56376e02-6db4-4697-857b-ffdcea59445a")

      expect(tuid.inspect).to eql("#<TUID 56376e02-6db4-4697-857b-ffdcea59445a (2015-11-02 14:06:58 UTC)>")
    end

  end

end
