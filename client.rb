require 'drb'

DRb.start_service
obj = DRbObject.new(nil, 'druby://localhost:9000')
print "input dictionary is: "
puts obj.dictionary.join(",")

def main_menu
  "To add string press 1: \nTo check the word press 2: \nTo find words by it's part press 3: \nTo add string from txt file press 4: \nTo add string from zip file press 5: \nTo add string to txt file press 6: \nTo add string to zip file press 7: "
end

loop do

  puts main_menu
  case gets.chomp
    when '1'
      print "Enter string: "
      str = gets.chomp
      obj.add_word str unless str.empty?
      print 'new dictionary is: '
      puts obj.dictionary.join(",")
    when '2'
      print "Enter word: "
      str = gets.chomp
      str = str.split("")
      puts obj.find_input_word_in_dictionary(str)
    when '3'
      print "Enter word: "
      str = gets.chomp
      if str.length > 2
        output_string = obj.find_like_words_in_dictionary(str)
        if output_string.length > 0
          print 'like words are: '
          puts output_string
        else
          puts "nothing is found"
        end
      else
        puts "min number of letters is 3"
      end
    when '4'
      print "Enter txt-file path: "
      path = gets.chomp
      string_from_txt_file = obj.load_from_file path unless path.empty?
      print 'new dictionary is: '
      puts obj.dictionary.join(",")
    when '5'
      print "Enter zip-file path: "
      path = gets.chomp
      obj.load_from_zip_file(path)
      print 'new dictionary is: '
      puts obj.dictionary.join(",")
    when '6'
      dictionary = obj.dictionary.join(",")
      print "Enter txt-file path: "
      path = gets.chomp
      obj.load_to_file(path) unless path.empty?
    when '7'
      print "Enter zip-file folder: "
      folder = gets.chomp
      print "Enter zip-file name: "
      zip_file_name = gets.chomp
      obj.load_to_zip_file(folder,zip_file_name)
    else
      puts "wrong key"
  end
  print "To continue work with app press 1: "
  break unless gets.chomp == '1'

end
