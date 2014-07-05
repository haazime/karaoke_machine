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
    new(
      string.split('').map{|n| Note.from_string(n) }
    )
  end

  def initialize(notes)
    @notes = notes
  end

  def play
    @notes.map {|n| n.play }.join
  end

  def transpose(amount)
    new_notes = @notes.map {|n| n.change(amount) }
    self.class.new(new_notes)
  end
end

class Note
  SEQUENCE = %w|C C# D D# E F F# G G# A A# B|

  def self.from_string(string)
    index = SEQUENCE.index(string)
    if index
      new(index, string)
    else
      NilNote.new(string)
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
    new_name = SEQUENCE.values_at(@index + amount)
    self.class.from_string(new_name)
  end
end

class NilNote < Struct.new(:name)

  def change(amount)
    self
  end

  def play
    self.name
  end
end
