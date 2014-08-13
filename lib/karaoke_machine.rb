class KaraokeMachine
  TONES = %w|C C# D D# E F F# G G# A A# B|

  def initialize(melody)
    @melody = melody
  end

  def transpose(amount)
    @melody.gsub(/[A-G]#?/, converting_hash(amount))
  end

private

  def converting_hash(amount)
    transposed = TONES.rotate(amount % TONES.size)
    Hash[TONES.zip(transposed)]
  end
end
