require "tuid/version"
require "securerandom"

# TUID value.
#
# TUIDs are values compatible with UUID
#
# They share the same base format so can be used instead of them.
# The main property of them is that they are prefixed by the time they
# were generated. This allow them to be sorted and behave better on database
# indexes.
#
class TUID
  attr_reader :bytes
  include Comparable

  # Initialize a new TUID
  #
  # @overload initialize
  #     @return Random TUID based on the current time
  #
  # @overload initialize(data)
  #     @param data [String] TUID string representation.
  #     @return TUID object equivalent to the passed string
  #
  # @overload initialize(time)
  #     @param time [Time] Reference time.
  #     @return Random TUID using the given generation time.
  def initialize(data=nil)
    data ||= Time.now

    @bytes = case data
    when TUID
      data.bytes
    when String
      case data.size
      when 16 # Raw byte array
        data.frozen? ? data : data.dup
      when 36 # Human-readable UUID representation
        elements = data.split("-")
        raise TypeError, "Expected #{data.inspect} to cast to a #{self.class} (malformed UUID representation)" if elements.size != 5
        [elements.join].pack('H32')
      else
        raise TypeError, "Expected #{data.inspect} to cast to a #{self.class} (invalid bytecount)"
      end
    when Time
      [
        data.to_i
      ].pack("N") + SecureRandom.random_bytes(12)
    else
      raise TypeError, "Expected #{data.inspect} to cast to a #{self.class} (invalid type)"
    end.freeze
  end

  # Compares two TUIDs.
  #
  # @return [-1,0,1] the compare result.
  def <=>(other)
    self.bytes <=> other.bytes
  end

  def inspect
    "#<#{self.class.name} #{to_s}(#{time})>"
  end

  # Get the TUID in UUID string format.
  #
  # @return [String] formatted as XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX
  def to_s
    "%08x-%04x-%04x-%04x-%04x%08x" % bytes.unpack("NnnnnN")
  end
  alias :to_str :to_s

  # Extract the time at which the TUID was generated.
  #
  # @return [Time] the generation time.
  def time
    Time.at(*bytes.unpack("N"))
  end

end
