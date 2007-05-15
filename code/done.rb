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
  include DesignByContract
  attr_reader :attacks, :discards

  # new : ListOf-Attack ListOf-Squadron -> Done
  # 
  # Creates a new object of type Done.
  def initialize(attacks, discards)
    create(attacks, discards)
  end

  # create : ListOf-Attack ListOf-Squadron -> Done
  # 
  # Creates a new Object of type Done.
  pre(:create, "Done takes a ListOf-Attack."){|attacks, discards|
    attacks.all?{|attack| attack.valid?}}
  pre(:create, "Done takes a ListOf-Attack 2."){|attacks, discards|
    attacks.instance_of?(Array)}
  pre(:create, "Done takes a ListOf-Squadron."){|attacks, discards|
    discards.all?{|discard| discard.squadron?} && discards.instance_of?(Array)}
  def create(attacks, discards)
    @attacks = attacks    # ListOf-Attack
    @discards = discards  # ListOf-Squadron
  end

  # ret? : Done -> Boolean
  # 
  # Is this Done a Ret?
  def ret?
    false
  end

  # end? : Done -> Boolean
  # 
  # Is this Done an End?
  def end?
    false
  end
  
  # Done.xml_to_done : Document -> Done
  #
  # Converts the XML into a Done.
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
    create(attacks, discards, card)
  end

  # create : ListOf-Attack ListOf-Squadron Card -> Ret
  #
  # Creates a new Done of type Ret.
  pre(:create, "Done takes a Card."){|attacks, discards, card| card.kind_of?(Card)}
  post(:create, "Must create type Ret"){|result, attacks, discards| result.ret?}
  def create(attacks, discards, card)
    super(attacks, discards)
    @card = card    # Card
  end

  # Ret? : Done -> Boolean
  # 
  # Is this Done a Ret?
  def ret?
    true
  end

  # equal? : Ret Done -> Boolean
  #
  # Are these two Rets equal?
  def equal?(other)
    other.ret? &&
    @attacks == other.attacks &&
    @discards == other.discards &&
    @card == other.card
  end
  
  # done_to_xml : Ret -> Document
  #
  # Converts this Ret into an XML String.
  def done_to_xml
    document = Document.new
    ret = document.add_element "RET"
    ret.add_element @card.card_to_xml
    slst = ret.add_element "LIST"
    @discards.each{|squadron|
      squadron = slst.add_element squadron.squadron_to_xml
    }
    @attacks.each{|attack|
      atck = ret.add_element attack.attack_to_xml
    }
  
    document
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
    create(attacks, discards, card)
  end
  
  # create : ListOf-Attack ListOf-Squadron (or Card Boolean) -> End
  #
  # Creates a new Done of type End.
  pre(:create, "Done takes a Card or False."){|attacks, discards, card| 
    card.kind_of?(Card)|| card.instance_of?(FalseClass)}
  post(:create, "Must create type End"){|result, attacks, discards| result.end?}
  def create(attacks, discards, card)
    super(attacks, discards)
    @card = card    # Card or Boolean
  end

  # end? : Done -> Boolean
  # 
  # Is this Done an End
  def end?
    true
  end
   
  # equal? End Done -> Boolean
  #
  # Are these two Ends the same?
  def equal?(other)
    other.end? &&
    @attacks == other.attacks &&
    @discards == other.discards &&
    @card == other.card
  end
  
  # done_to_xml : End -> String
  #
  # Converts this End into an XML String.
  def done_to_xml
    document = Document.new
    ed = document.add_element "END"
    if @card.nil?
      ed.add_element "FALSE"
    else
      ed.add_element @card.card_to_xml
    end
    slst = ed.add_element "LIST"
    @discards.each{|squadron|
      squadron = slst.add_element squadron.squadron_to_xml
    }
    @attacks.each{|attack|
      atck = ed.add_element attack.attack_to_xml
    }
  
    document
  end
end
