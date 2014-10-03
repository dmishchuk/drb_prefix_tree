require 'drb'
require 'rubygems'
require 'bundler/setup'
require 'storage_gem'
class DrbObj
  def initialize
    @storage = StorageGem::Storage.new
    @storage.load_from_file('data.txt')
  end

  def add_word(word)
    @storage.add(word)
  end

  def dictionary
    @storage.dictionary
  end

  def find_input_word_in_dictionary(str)
    dictionary_array = @storage.leafs_array
    begin
      @storage.find_word(str, dictionary_array)
    rescue StorageGem::MatchNotFound
      return "Not found :("
    else
      return 'Found :)'
    end
  end

  def find_like_words_in_dictionary(str)
    str_storage = str
    str = str.split("")
    dictionary_array = @storage.leafs_array
    @storage.find_like_words(str, dictionary_array)
    @storage.parse_like_words(str_storage)
    return @storage.like_words.join(",")
  end

  def load_from_file(path)
    @storage.load_from_file(path)
  end

  def load_from_zip_file(path)
    input_array = []
    Zip::File.open(path) do |zip_file|
      zip_file.each do |entry|
        content = entry.get_input_stream.read
        input_array.push(content)
      end
    end
    input_string = input_array.join(",")
    add_word input_string unless input_string.empty?
  end

  def load_to_file(path)
    @storage.load_to_file(path, dictionary.join(","))
  end

  def load_to_zip_file(folder, zip_file_name)
    @storage.load_to_file(folder + "/data.txt", dictionary.join(","))
    Zip::File.open(folder + '/' + zip_file_name, Zip::File::CREATE) do |zipfile|
      zipfile.add("data.txt", folder + "/data.txt")
    end
    File.delete(folder + "/data.txt")
  end
end

DRb.start_service('druby://localhost:9000', DrbObj.new)
DRb.thread.join