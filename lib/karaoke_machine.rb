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
      if ToneResolver === token
        ToneResolver.create_tone_from_string(token)
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
    @notes.map {|n| n.to_s(ToneResolver) }.join
  end
end

module ToneResolver
  extend self

  @names = %w|C C# D D# E F F# G G# A A# B|

  def create_tone_from_string(string)
    Tone.new(@names.index(string))
  end

  def resolve(index)
    @names.at(index.modulo(@names.size))
  end

  def ===(candidate)
    @names.include?(candidate)
  end
end

class Tone

  def initialize(index)
    @index = index
  end

  def transpose(amount)
    self.class.new(@index + amount)
  end

  def to_s(resolver)
    resolver.resolve(@index)
  end
end

class RestOrBar < Struct.new(:string)

  def transpose(*args)
    self
  end

  def to_s(*args)
    self.string
  end
end
