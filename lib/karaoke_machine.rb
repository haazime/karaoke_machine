class KaraokeMachine

  def initialize(melody_string)
    @melody = Melody.parse(melody_string)
  end

  def transpose(amount)
    @melody.transpose(amount).to_s
  end
end

class Melody

  def self.parse(string)
    notes = string.scan(/(?:[A-G]#?|[ \|])/).map do |token|
      if ToneSequence === token
        Tone.new(token)
      else
        RestOrBar.new(token)
      end
    end
    new(notes)
  end

  def initialize(notes)
    @notes = notes
  end

  def transpose(amount)
    self.class.new(@notes.map {|n| n.transpose(amount) })
  end

  def to_s
    @notes.map {|n| n.to_s }.join
  end
end

module ToneSequence
  extend self

  @names = %w|C C# D D# E F F# G G# A A# B|

  def transpose(current, amount)
    new_index = (@names.index(current) + amount).modulo(@names.size)
    @names.at(new_index)
  end

  def ===(candidate)
    @names.include?(candidate)
  end
end

class Tone

  def initialize(name, sequence=ToneSequence)
    @name = name
    @sequence = sequence
  end

  def transpose(amount)
    self.class.new(@sequence.transpose(@name, amount))
  end

  def to_s
    @name
  end
end

class RestOrBar < Struct.new(:string)

  def transpose(*args)
    self
  end

  def to_s
    self.string
  end
end
