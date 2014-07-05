class KaraokeMachine

  def initialize(melody_string)
    @melody = Melody.from_string(melody_string)
  end

  def transpose(amount)
    @melody.transpose(amount).play
  end
end

class Melody

  def self.from_string(string)
    new(Note.parse_from_string(string))
  end

  def initialize(notes)
    @notes = notes
  end

  def play
    @notes.map {|n| n.play }.join
  end

  def transpose(amount)
    self.class.new(@notes.map {|n| n.change(amount) })
  end
end

class Note
  @sequence = %w|C C# D D# E F F# G G# A A# B|

  class << self

    def parse_from_string(string)
      string.scan(/(?:[A-G]#?|[ \|])/).map {|s| from_string(s) }
    end

    def resolve_name(amount)
      @sequence.at(amount.modulo(@sequence.size))
    end

    def from_string(string)
      if index = @sequence.index(string)
        new(index, string)
      else
        NilNote.new(string)
      end
    end
  end

  def initialize(index, name)
    @index = index
    @name = name
  end

  def play
    @name
  end

  def change(amount)
    new_name = self.class.resolve_name(@index + amount)
    self.class.from_string(new_name)
  end

  class NilNote < Struct.new(:name)

    def change(amount)
      self
    end

    def play
      self.name
    end
  end
end
