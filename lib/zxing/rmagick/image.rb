require 'mini_magick'

module ZXing; end
module ZXing::RMagick; end

class ZXing::RMagick::Image
  include ZXing::Image
  LuminanceSource = ZXing::FFI::Common::GreyscaleLuminanceSource

  def self.read argument
    img = MiniMagick::Image.open(argument)
    self.new img
  end

  def rotate angle
    self.class.new @native.rotate(angle)
  end

  def width
    @native[:width]
  end

  def height
    @native[:height]
  end

  def gray
    file_postfix = 'stream'
    path = "#{@native.path}-#{file_postfix}"
    MiniMagick::Tool::Stream.new do |s|
      s.map 'i', '-storage-type', 'char', @native.path, path
    end
    File.read(path)
  end

  private

  def self.fetch(uri, limit = 10)
    # You should choose better exception.
    raise ArgumentError, 'HTTP redirect too deep' if limit == 0

    require 'net/http'

    response = Net::HTTP.get_response(uri)
    case response
    when Net::HTTPSuccess; response
    when Net::HTTPRedirection
      fetch(URI.parse(response['location']), limit-1)
    else
      response.error!
    end
  end
end
