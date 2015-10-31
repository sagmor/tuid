require "tuid/version"
require "securerandom"

class TUID
  attr_reader :bytes
  include Comparable

  def initialize(data=nil)
    data ||= Time.now

    @bytes = case data
    when TUID
      data.bytes
    when String
      case string.size
      when 16 # Raw byte array
        string.frozen? ? string : string.dup
      when 32 # Human-readable UUID representation
        elements = bytes.split("-")
        raise TypeError, "Expected #{bytes.inspect} to cast to a #{self.class} (malformed UUID representation)" if elements.size != 5
        [elements.join].pack('H32')
      else
        raise TypeError, "Expected #{string.inspect} to cast to a #{self.class} (invalid bytecount)"
      end
    when Time
      [
        data.to_i
      ].pack("N") + SecureRandom.random_bytes(12)
    end.freeze
  end

  def <=>(other)
    self.bytes <=> other.bytes
  end

  def inspect
    "#<#{self.class.name} #{to_s}(#{time})>"
  end

  def to_s
    "%08x-%04x-%04x-%04x-%04x%08x" % bytes.unpack("NnnnnN")
  end
  alias :to_str :to_s

  def time
    Time.at(*bytes.unpack("N"))
  end

end
