class KaraokeMachine
  TONES = %w|C C# D D# E F F# G G# A A# B|

  def initialize(melody)
    @melody = melody
  end

  def transpose(amount)
    @melody
      .scan(/[A-G]#?|[ \|]/)
      .map {|e| TONES.at((TONES.index(e) + amount) % TONES.size) rescue e }
      .join
  end
end
