# !/arch/unix/bin/ruby

# done.rb
# First included in Project 5
# Includes classes for Done.

# Class method for Done. There are two different
# types of Done used in the program:
# * Ret
# * End
# A Ret is used when the game keeps playing and the
# Player returns a Card to the Stack. An End is used when
# the Player is ending the Battle. The Player can either return
# a Card to the Stack or return nil because they played their
# last Card in an Attack or discard.
class Done
  attr_reader :attacks, :discards

  # new : ListOf-Attack ListOf-Squadron -> Done
  #
  # Creates a new Object of type Done.
  def initialize(attacks, discards)
    @attacks = attacks # ListOf-Attack
    @discards = discards # ListOf-Squadron
  end

  # Done.xml_to_done : Document -> Done
  # done = <END> borc slst atck ... </END>
  #    | <RET> card slst atck ... </RET>
  def Done.xml_to_done(doc)
    discards = []
    doc.elements.each('//LIST/SQUADRON') {|element|
      element = Document.new element.to_s
      discards << Squadron.xml_to_squad(element)
    }

    attacks = []
    doc.elements.each('//ATTACK') {|element|
      fighter_doc = Document.new element.elements[1].to_s
      bomber_doc = Document.new element.elements[2].to_s
      fighter = Squadron.xml_to_squad(fighter_doc)
      bomber = Squadron.xml_to_squad(bomber_doc)
      attacks << Attack.new(fighter, bomber)
    }
    
    if doc.root.name == 'END'
      if doc.root.elements[1].name == 'FALSE'
      borc = nil
      else
      input = Document.new doc.root.elements[1].to_s
      borc = Card.xml_to_card(input)
      end
      return End.new(attacks, discards, borc)
    elsif doc.root.name == 'RET'
      input = Document.new doc.root.elements[1].to_s
      card = Card.xml_to_card(input)
      return Ret.new(attacks, discards, card)
    end
  end
end

# Ret inherits from the Done class. A Ret means that the Player
# has not finished the Battle and is returning a Card to the Stack.
class Ret < Done
  attr_reader :card

  # new : ListOf-Attack ListOf-Squadron Card -> Ret
  #
  # Creates a new Done of type Ret.
  def initialize(attacks, discards, card)
    super(attacks, discards)
    @card = card
  end

  # equal? : Ret Done -> Boolean
  #
  # Are these two Rets equal?
  def equal?(other)
    other.instance_of?(Ret) &&
    @attacks == other.attacks &&
    @discards == other.discards &&
    @card == other.card
  end
  
  # done_to_xml : Ret -> String
  #
  # Converts this Ret into an XML String.
  def done_to_xml
    card = @card.card_to_xml

    if @discards.empty?
      slist = "<LIST />"
    else
      slist = "<LIST>"
      @discards.each{|x|
      slist << "<SQUADRON>"
      x.list_of_cards.each{|y| slist << y.card_to_xml}
      slist << "</SQUADRON>"
      }
      slist << "</LIST>"
    end

    if @attacks.empty?
      atck = ""
    else
      atck = ''
      @attacks.each{|x|
      atck << "<ATTACK>"
      atck << x.fighter.squadron_to_xml
      atck << x.bomber.squadron_to_xml
      atck << "</ATTACK>"
    }
    end
    
    "<RET>" + card + slist + atck + "</RET>"
  end
end

# End inherits from the Done class. An End is used
# whenever the Battle ends because the Player does not
# have any cards left in their Hand. They can either return
# a Card to the Stack or return nil because they played their
# last Card in an Attack or discard.
class End < Done
  attr_reader :card

  # new : ListOf-Attack ListOf-Squadron Card -> End
  #
  # Creates a new Done of type End.
  def initialize(attacks, discards, card)
    super(attacks, discards)
    @card = card
  end
  
  # equal? End Done -> Boolean
  #
  # Are these two Ends the same?
  def equal?(other)
    other.instance_of?(End) &&
    @attacks == other.attacks &&
    @discards == other.discards &&
    @card == other.card
  end
  
  # done_to_xml : End -> String
  #
  # Converts this End into an XML String.
  def done_to_xml
    if @card.nil?
      borc = "<FALSE />"
    else
      borc = @card.card_to_xml
    end
    if @discards.empty?
      slist = "<LIST />"
    else
      slist = "<LIST>"
      @discards.each{|x|
      slist << "<SQUADRON>"
      x.list_of_cards.each{|y| slist << y.card_to_xml}
      slist << "</SQUADRON>"
      }
      slist << "</LIST>"
    end

    if @attacks.empty?
      atck = ""
    else
      atck = ''
      @attacks.each{|x|
      atck << "<ATTACK>"
      atck << x.fighter.squadron_to_xml
      atck << x.bomber.squadron_to_xml
      atck << "</ATTACK>"
    }
    end
    
    "<END>" + borc + slist + atck + "</END>"
  end
end
