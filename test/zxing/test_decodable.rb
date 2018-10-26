require File.expand_path( File.dirname(__FILE__) + '/../test_helper')
require 'zxing/decodable'

class DecodableTest < MiniTest::Test

  class Object::File
    include Decodable
  end

  class URL
    include Decodable
    def initialize(path)
      @path = path
    end
    def path; @path end
  end

  describe "A Decodable module" do
    before do
      @file = File.open( File.expand_path( File.dirname(__FILE__) + '/../qrcode.png' ))
      @uri = URL.new "http://2d-code.co.uk/images/bbc-logo-in-qr-code.gif"
      @bad_uri = URL.new "http://google.com"
    end

    it "provide #decode to decode the return value of #path" do
      assert_equal @file.decode, ZXing.decode(@file.path)
    end

    it "provide #decode! as well" do
      assert_equal @file.decode!, ZXing.decode(@file.path)
    end
  end

end
