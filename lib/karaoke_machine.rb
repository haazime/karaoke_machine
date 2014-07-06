class KaraokeMachine

  def initialize(melody_string)
    @melody = Melody.parse(melody_string)
  end

  def transpose(amount)
    @melody.transpose(amount).present
  end
end

class Melody

  def self.parse(string)
    notes = string.scan(/(?:[A-G]#?|[ \|])/).map do |token|
      Tone.from_string(token) || RestOrBar.new(token)
    end
    new(notes)
  end

  def initialize(notes)
    @notes = notes
  end

  def transpose(amount)
    self.class.new(@notes.map {|n| n.change(amount) })
  end

  def present
    @notes.inject("") {|melody, n| melody += n.present }
  end
end

class Tone
  NAMES = %w|C C# D D# E F F# G G# A A# B|

  def self.from_string(string)
    return nil unless NAMES.include?(string)
    Tone.new(NAMES.index(string))
  end

  def initialize(index)
    @index = index
  end

  def change(amount)
    new_index = (@index + amount).modulo(NAMES.size)
    self.class.new(new_index)
  end

  def present
    NAMES.at(@index)
  end
end

class RestOrBar < Struct.new(:string)

  def change(*args)
    self
  end

  def present
    self.string
  end
end
