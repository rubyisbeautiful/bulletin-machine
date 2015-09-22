require 'mini_magick'

class Thumbnailer

  class Config

    attr_accessor :input_path, :output_path

  end

  @config = Thumbnailer::Config.new

  def self.config
    @config
  end


  def self.configure(&block)
    yield @config
  end


  def thumbnail(input_file, output_file=nil)

    if output_file.nil?
      output_file = "#{File.basename(input_file, '.pdf')}.jpg"
    end

    if input_file =~ /\//
      full_input_path = input_file.to_s
    else
      full_input_path = Thumbnailer.config.input_path.join(input_file).to_s
    end
    
    if output_file =~ /\//
      full_output_path = output_file.to_s
    else
      full_output_path = Thumbnailer.config.output_path.join(output_file).to_s
    end
    

    image = MiniMagick::Image.open(full_input_path)
    image.resize '100x100'
    image.format 'jpg'
    image.write Thumbnailer.config.output_path.join(output_file)

  end


end
