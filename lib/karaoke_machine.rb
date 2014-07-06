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
      ToneResolver.create_tone_from_string(token) ||
        RestOrBar.new(token)
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
    @notes.inject("") {|melody, n| melody += n.present(ToneResolver) }
  end
end

module ToneResolver
  extend self

  @names = %w|C C# D D# E F F# G G# A A# B|

  def create_tone_from_string(string)
    return nil unless @names.include?(string)
    Tone.new(@names.index(string))
  end

  def resolve(index)
    @names.at(index.modulo(@names.size))
  end
end

class Tone

  def initialize(index)
    @index = index
  end

  def change(amount)
    self.class.new(@index + amount)
  end

  def present(resolver)
    resolver.resolve(@index)
  end
end

class RestOrBar < Struct.new(:string)

  def change(*args)
    self
  end

  def present(*args)
    self.string
  end
end
