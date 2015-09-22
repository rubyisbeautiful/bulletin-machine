require 'bundler'

require 'sinatra'
require_relative 'lib/thumbnailer'

class BulletinMachine < Sinatra::Base

  Thumbnailer.configure do |config|
    config.input_path = Pathname.new(File.expand_path(File.dirname(__FILE__))).join('data/bulletins/originals')
    config.output_path = Pathname.new(File.expand_path(File.dirname(__FILE__))).join('data/bulletins/thumbs')
  end


  post '/bulletins/:filename' do
    filename = params[:filename].to_s[/[\w\s]+\.\w{3}/]
    base_file_name = File.basename(filename, '.pdf')
    temp_file_path = nil

    Tempfile.open([base_file_name, '.pdf']) do |file|
      file.write request.body.read
      temp_file_path = file.path
    end

    Thumbnailer.new.thumbnail temp_file_path, "#{base_file_name}.jpg"

    'OK'
  end

end
