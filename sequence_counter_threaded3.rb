# sequence_counter: a tool for counting occurrences of letter sequences
# in a dictionary.

seq_size = (ARGV[1] || 4).to_i
start = Time.now
dict = ARGV[0]
word_file = File.open(dict)
sequences = Hash.new(0)
i = 0

# find letter sequences of size seq_size and increment their counts in
# the sequences hash
def count_seqs(word, seq_size, sequences)
  offset = 0
  while offset < (word.size - seq_size)
    sequences[word[offset, seq_size]] += 1
    offset+=1
  end
end

thread_count = (ARGV[2] || 1).to_i
queue = SizedQueue.new(thread_count * 2)
threads = thread_count.times.map do |i|
  Thread.new do
    count = 0
    while true
      word = queue.pop
      queue.shutdown if word.nil? # terminating condition
      count_seqs(word, seq_size, sequences)
      count+=1
      puts "Thread #{i} finished #{count}" if count % 100_000 == 0
    end
  end
end

word_file.each_line do |word|
  word.chomp!
  next if word.length < seq_size
  queue << word
end
queue << nil # terminating condition

top_ten = []
puts sequences.each.sort_by {|p, n| n}.last(10).reverse.map {|p, n| "#{p}: #{n}"}
