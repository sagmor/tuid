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

  # TUID binary representation
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
    @bytes = case data
    when TUID
      data.bytes
    when String
      bytes_from_string(data)
    when Time, NilClass
      random_bytes_with_time(data || Time.now)
    else
      raise type_error(data, "invalid type")
    end.freeze
  end

  # Compares two TUIDs.
  #
  # @return [-1,0,1] the compare result.
  def <=>(other)
    self.bytes <=> other.bytes
  end

  # Console friendly representation
  def inspect
    "#<#{self.class.name} #{to_s} (#{time.utc})>"
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

  # Compare two TUID objects
  def eql?(other)
    other.instance_of?(self.class) && self == other
  end

  private

    # Parse bytes from String
    def bytes_from_string(string)
      case string.length
      when 16
        string.frozen? ? string : string.dup
      when 36
        elements = string.split("-")
        raise type_error(string, "malformed UUID representation") if elements.size != 5
        [elements.join].pack('H32')
      else
        raise type_error(string, "invalid bytecount")
      end
    end

    # Generate bytes string with the given time
    def random_bytes_with_time(time)
      bytes = [
        time.to_i
      ] + SecureRandom.random_bytes(12).unpack("nnnnN")
      bytes[2] = (bytes[2] & 0x0fff) | 0x4000
      bytes[3] = (bytes[3] & 0x3fff) | 0x8000

      bytes.pack("NnnnnN")
    end

    # Create a formatted type error.
    def type_error(source,error)
      TypeError.new("Expected #{source.inspect} to cast to a #{self.class} (#{error})")
    end

end
