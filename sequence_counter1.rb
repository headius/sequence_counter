# sequence_counter: a tool for counting occurrences of letter sequences
# in a dictionary.

seq_size = (ARGV[1] || 4).to_i
start = Time.now
dict = ARGV[0]
words = File.readlines(dict)
sequences = Hash.new(0)
i = 0

# find letter sequences of size seq_size and increment their counts in
# the sequences hash
def count_seqs(word, seq_size, sequences)
  unpacked = word.unpack('C*')
  0.upto(unpacked.size - seq_size - 1) do |offset|
    sequences[unpacked[offset, seq_size].pack('C*')] += 1
  end
end

words.each do |word|
  word.chomp!
  next if word.length < seq_size
  count_seqs(word, seq_size, sequences)
  i += 1
  puts "#{i} processed" if i % 100000 == 0
end

top_ten = []

puts sequences.each.sort_by {|p, n| n}.last(10).reverse.map {|p, n| "#{p}: #{n}"}
