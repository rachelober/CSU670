# !/arch/unix/bin/ruby

# xmlhelper.rb
# Used to help parse xml into objects
# and to turn objects into valid xml

# required files
require 'rexml/document'
require 'code/card.rb'
require 'code/stack.rb'
include REXML

class XMLHelper
    # ----------------------------------------
    # Converting XML into Objects
    # ----------------------------------------
    
    # XMLHelper.xml_to_card : XML -> Card
    def XMLHelper.xml_to_card(card_xml)
        file = File.new('aircrafts/index.xml')
        doc = Document.new file
        root = card_xml.root
    
        if(root.name == 'AIRCRAFT')
            # Gets information from the xml given from standardout
            name = root.attributes['NAME']
            tag = root.attributes['TAG'].to_i
            # Gathers information from index.xml to create new Aircraft
            from_file = XPath.match(doc, "//aircraft[@name='#{name}']")
            nation = from_file[0].attributes['nation']
            category = from_file[0].attributes['category']
            image = from_file[0].attributes['image']
            # Make new objects
            if(category == 'fighter')
                category = Fighter.new
            else
                category = Bomber.new
            end
            if(nation == 'axis')
                nation = Axis.new
            else
                nation = Allies.new
            end
            image = Image.new(image)
            # Create a new Aircraft Card
            return Aircraft.new(image, name, nation, category, tag)
        elsif(root.name == "KEEPEM")
            # Gets information from the xml given from standardout
            tag = root.attributes['TAG']
            image = Image.new('keepem.jpg')
            # Create new Keepem Card
            return Keepem.new(image, tag)
        elsif(root.name == "VICTORY")
            image = Image.new('victory.jpg')
            # Create a new Victory Card
            return Victory.new(image)
        end
    end

    # XMLHelper.xml_okay? : XML -> Boolean
    def XMLHelper.xml_okay?(xml)
        root = xml.root
    
        root.name == 'OKAY'
    end
   
    # XMLHelper.xml_to_done : XML -> Done
    # done = <END> borc slst atck ... </END>
    #      | <RET> card slst atck ... </RET>
    def XMLHelper.xml_to_done(doc)
        discards = []
        doc.elements.each('*/LIST') {|element|
            discards << XMLHelper.xml_to_squad(element.elements[1])
        }

        attacks = []
        doc.elements.each('*/ATTACK') {|element|
            fighter = XMLHelper.xml_to_squad(element.elements[1])
            bomber = XMLHelper.xml_to_squad(element.elements[2])
            attacks << Attack.new(fighter, bomber)
        }
        
        if doc.root.name == 'END'
            if doc.root.elements[1].name == 'FALSE'
                borc = nil
            else
                input = Document.new doc.root.elements[1].to_s
                borc = XMLHelper.xml_to_card(input)
            end
            
            done = End.new(attacks, discards, borc)
        elsif doc.root.name == 'RET'
            input = Document.new doc.root.elements[1].to_s
            card = XMLHelper.xml_to_card(input)
            
            done = Ret.new(attacks, discards, card)
        end
    
        return done
    end
    
    # XMLHelper.xml_to_squad : XML -> Squadron
    def XMLHelper.xml_to_squad(doc)
        squad_list = []
        
        doc.elements.each('*') {|element|
            input = Document.new element.to_s
            squad_list << XMLHelper.xml_to_card(input)
        }
        Squadron.new(squad_list)
    end
    
    # XMLHelper.xml_to_fsth : STDIN -> Array
    def XMLHelper.xml_to_fsth(fsth_xml)
        doc = Document.new fsth_xml
        
        hand = []
        doc.elements.each('SQUADRON/*') {|element|
            hand << XMLHelper.xml_to_card(element)
        }
        hand
    end
    
    # XMLHelper.xml_to_turn : STDIN -> Boolean Stack (ListOf Squadrons)
    def XMLHelper.xml_to_turn(turn_xml)
        doc = Document.new turn_xml
        root = doc.root
        
        if XPath.match(doc, "//TRUE")
            bool = true
        else
            bool = false
        end

        stck = []
        doc.elements.each('TURN/STACK/*'){ |element|
            element = Document.new element.to_s
            stck << XMLHelper.xml_to_card(element)
        }
        stck = Stack.create(stck)

        slist = []
        doc.elements.each('TURN/LIST/SQUADRON') {|element|
            squad = []
            element.elements.each() {|card|
                card = Document.new card.to_s
                squad << XMLHelper.xml_to_card(card)
            }
            slist << squad
        }
        return bool, stck, slist
    end

    # XMLHelper.xml_to_xturn : STDIN -> Turn
    def XMLHelper.xml_to_xturn(turn_xml)
        doc = Document.new turn_xml
        
        # Loaded array
        # This will take care of both stack and deck
        # So array has two elements, the first being the deck 
        # and the second taking care of the stack
        stack_and_deck = []
        doc.elements.each('TURN/STACK'){|element|
            list_of_cards = []
            element.elements.each('*'){|card|
                array << XMLHelper.xml_to_card
            }
            stack_and_deck << list_of_cards
        }
        deck = Deck.list_to_deck(stack_and_deck[0])
        stack = Stack.create(stack_and_deck[1])

        list_of_squads = []
        doc.elements.each('TURN/LIST'){|element|
            squad = Squadron.new(nil)
            element.elements.each('SQUADRON/*'){|card|
                squad.add_card << card
            }
            list_of_squads << squad
        }

        Turn.new(deck, stack, list_of_squads)
    end

    # ----------------------------------------
    # Converting Objects into XML
    # ----------------------------------------

    # XMLHelper.card_to_xml : Card -> String
    def XMLHelper.card_to_xml(card)
        if card.instance_of?(Aircraft)
            return "<AIRCRAFT NAME=\"#{card.name}\" TAG=\"#{card.tag}\" />"
        elsif card.instance_of?(Keepem)
            return "<KEEPEM TAG=\"#{card.index}\" />"
        else
            return '<VICTORY />'
        end
    end

    # XMLHelper.done_to_xml : Done -> String
    def XMLHelper.done_to_xml(done)
        if done.card.nil?
            borc = "<FALSE />"
        else
            borc = XMLHelper.card_to_xml(done.card)
        end
        slist = '<LIST>'
        if done.discards.empty?
            slist << '<SQUADRON />'
        else
            done.discards.each{|x|
                slist << '<SQUADRON>'
                    done.discards.list_of_squadrons.each{|y|
                        slist << XMLHelper.card_to_xml(y)
                    }
                slist << '</SQUADRON>'
            }
        end
        slist << '</LIST>'

        if done.attacks.empty?
            atck = '<ATTACK />'
        else
            atck = ''
            done.attacks.each{|x|
                atck = '<ATTACK>'
                atck << '<SQUADRON>'
                done.discards.fighter.each{|y|
                    atck << XMLHelper.card_to_xml(y)
                }
                atck << '</SQUADRON>'
                atck << '<SQUADRON'
                done.discards.bomber.each{|y|
                    atck << XMLHelper.card_to_xml(y)
                }
                atck << '</SQUADRON>'
                atck << '</ATTACK>'
            }
        end

        if done.instance_of?(End)
            return '<END>' + borc + slist + atck + '</END>'
        elsif done.instance_of?(Ret)
            return '<RET>' + card + slist + atck + '</RET>'
        end
    end

    # XMLHelper.boolean_to_xml : Boolean -> String
    def XMLHelper.boolean_to_xml(boolean)
        if boolean
            return '<TRUE />'
        else
            return '<FALSE />'
        end
    end

    # XMLHelper.squadron_to_xml : Squadron -> String
    def XMLHelper.squadron_to_xml(squadron)
        if squadron.list_of_cards.size == 0
            result = '<SQUADRON />'
        else
            result = '<SQUADRON>'
            squadron.list_of_cards.each{|x|
                result = result + XMLHelper.card_to_xml(x)
            }
            result = result + '</SQUADRON>'
        end
        return result
    end

    # XMLHelper.attack_to_xml : Attack -> String
    def XMLHelper.attack_to_xml(attack)
        if (attack.fighter.list_of_cards.size == 0) && (attack.bomber.list_of_cards.size == 0)
            result = '<ATTACK />'
        else
            result = '<ATTACK>'
            # Fighter
            result = result + XMLHelper.squadron_to_xml(attack.fighter)
            # Bombers
            result = result + XMLHelper.squadron_to_xml(attack.bomber)
            result = result + '</ATTACK>'
        end
        return result
    end

    # XMLHelper.cardsfrom_to_xml : CardsFrom -> String
    def XMLHelper.cardsfrom_to_xml(cardsfrom)
        if cardsfrom.instance_of?(FromStack)
            return "<STACK NO=\"#{cardsfrom.how_many_cards?}\"/>"
        elsif cardsfrom.instance_of?(FromDeck)
            return "<DECK />"
        end
    end
end
