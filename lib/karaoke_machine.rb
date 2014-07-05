class KaraokeMachine

  def initialize(melody_string)
    @melody = MelodyParser.parse(melody_string)
  end

  def transpose(amount)
    return "" if @melody.empty?
    @melody.transpose(amount).present
  end
end

class Key
  @sequence = %w|C C# D D# E F F# G G# A A# B|

  class << self

    def resolve_index(name)
      @sequence.index(name)
    end

    def resolve_name(index)
      @sequence.at(index.modulo(@sequence.size))
    end

    def from_amount(amount)
      from_string(resolve_name(amount))
    end

    def from_string(name)
      new(resolve_index(name), name)
    end
  end

  def initialize(index, name)
    @index = index
    @name = name
  end

  def change(amount)
    self.class.from_amount(@index + amount)
  end

  def fix(degree_amount)
    self.class.resolve_name(@index + degree_amount)
  end

  def to_s
    @name
  end

  def ==(other)
    self.to_s == other.to_s
  end
end

module MelodyParser
  extend self

  def parse(string)
    elements = string.scan(/(?:[A-G]#?|[ \|])/)
    key = Key.from_string(elements.first)
    notes = elements.map do |e|
      case e
      when /[A-G]#?/; Degree.new(Key.resolve_index(e))
      when ' '      ; Rest
      when '|'      ; Bar
      end
    end
    Melody.new(key, notes)
  end
end

class Melody

  def initialize(key, notes)
    @key = key
    @notes = notes
  end

  def present
    @notes.inject("") {|r, n| r += n.fix(@key) }
  end

  def transpose(amount)
    self.class.new(@key.change(amount), @notes)
  end

  def empty?
    @notes.empty?
  end
end

class Degree

  def initialize(amount)
    @amount = amount
  end

  def fix(key)
    key.fix(@amount)
  end
end

module Rest
  extend self

  def fix(*args)
    " "
  end
end

module Bar
  extend self

  def fix(*args)
    '|'
  end
end
