# sequence_counter: a tool for counting occurrences of letter sequences
# in a dictionary.

seq_size = (ARGV[0] || 4).to_i
start = Time.now
dict = 'big_list'
words = File.readlines(dict)
sequences = Hash.new(0)
i = 0
words.each do |word|
  word.chomp!
  next if word.length < seq_size
  unpacked = word.unpack('C*')
  prev_chars = []
  0.upto(unpacked.size - seq_size - 1) do |offset|
    sequences[unpacked[offset, seq_size].pack('C*')] += 1
  end
  i += 1
  puts "#{i} processed" if i % 100000 == 0
end

top_ten = []

puts sequences.each.sort_by {|p, n| n}.last(10).reverse.map {|p, n| "#{p}: #{n}"}
