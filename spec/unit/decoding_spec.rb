require File.expand_path('../spec_helper.rb', File.dirname(__FILE__))

describe ChunkyPNG::PixelMatrix::Decoding do
  include ChunkyPNG::PixelMatrix::Decoding
  
  describe '#decode_scanline' do
    
    it "should decode a line without filtering as is" do
      bytes = [255, 255, 255, 255, 255, 255, 255, 255, 255]
      decode_scanline(ChunkyPNG::FILTER_NONE, bytes, nil).should == bytes
    end
    
    it "should decode a line with sub filtering correctly" do
      # all white pixels
      bytes = [255, 255, 255, 0, 0, 0, 0, 0, 0]
      decoded_bytes = decode_scanline(ChunkyPNG::FILTER_SUB, bytes, nil)
      decoded_bytes.should == [255, 255, 255, 255, 255, 255, 255, 255, 255]
      
      # all black pixels
      bytes = [0, 0, 0, 0, 0, 0, 0, 0, 0]
      decoded_bytes = decode_scanline(ChunkyPNG::FILTER_SUB, bytes, nil)
      decoded_bytes.should == [0, 0, 0, 0, 0, 0, 0, 0, 0]
      
      # various colors
      bytes = [255, 0, 45, 0, 255, 0, 112, 200, 178]
      decoded_bytes = decode_scanline(ChunkyPNG::FILTER_SUB, bytes, nil)
      decoded_bytes.should == [255, 0, 45, 255, 255, 45, 111, 199, 223]
    end
    
    it "should decode a line with up filtering correctly" do
      # previous line is all black
      previous_bytes = [0, 0, 0, 0, 0, 0, 0, 0, 0]
      bytes          = [255, 255, 255, 127, 127, 127, 0, 0, 0]
      decoded_bytes  = decode_scanline(ChunkyPNG::FILTER_UP, bytes, previous_bytes)
      decoded_bytes.should == [255, 255, 255, 127, 127, 127, 0, 0, 0]
      
      # previous line has various pixels
      previous_bytes = [255, 255, 255, 127, 127, 127, 0, 0, 0]
      bytes          = [0, 127, 255, 0, 127, 255, 0, 127, 255]
      decoded_bytes  = decode_scanline(ChunkyPNG::FILTER_UP, bytes, previous_bytes)
      decoded_bytes.should == [255, 126, 254, 127, 254, 126, 0, 127, 255]
    end
  end
end