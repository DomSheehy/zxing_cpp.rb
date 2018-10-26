require File.expand_path( File.dirname(__FILE__) + '/test_helper')
require 'shoulda'
require 'zxing'

class ZXingTest < MiniTest::Test
  describe "A QR decoder singleton" do

    class Foo < Struct.new(:v); def to_s; self.v; end; end

    before do
      @decoder = ZXing
      @uri = "http://2d-code.co.uk/images/bbc-logo-in-qr-code.gif"
      @path = File.expand_path( File.dirname(__FILE__) + '/qrcode.png')
      @file = File.new(@path)
      @google_logo = "http://www.google.com/logos/grandparentsday10.gif"
      @uri_result = "http://bbc.co.uk/programmes"
      @path_result = "http://rubyflow.com"
    end

    it "decode a file path" do
      assert_equal @decoder.decode(@path), @path_result
    end

    it "return nil if #decode fails" do
      assert_nil @decoder.decode(@google_logo)
    end

    it "raise an exception if #decode! fails" do
      assert_raises(ZXing::ReaderException,
                    ZXing::NotFoundException) { @decoder.decode!(@google_logo) }
    end
  end

  describe "A QR decoder module" do
    before do
      class SpyRing; include ZXing end
      @ring = SpyRing.new
    end

    it "include #decode and #decode! into classes" do
      assert @ring.method(:decode)
      assert @ring.method(:decode!)
    end
  end
end
