# !/arch/unix/bin/ruby

# done_tests.rb
# Test cases for done.rb

# Required Files
require 'test/unit'
require 'code/done.rb'

class TestDone < Test::Unit::TestCase
  def setup
    allies = Allies.new
    axis = Axis.new
    fighter = Fighter.new
    bomber = Bomber.new

    @air1 = Aircraft.new(Image.new("Baku Geki KI-99.gif"), "Baku Geki KI-99", axis, bomber, 1)
    @air2 = Aircraft.new(Image.new("Baku Geki KI-99.gif"), "Baku Geki KI-99", axis, bomber, 2)
    @air3 = Aircraft.new(Image.new("Baku Geki KI-99.gif"), "Baku Geki KI-99", axis, bomber, 3)
    @air4 = Aircraft.new(Image.new("Bell P-39D.gif"), "Bell P-39D", allies, fighter, 1)
    @air5 = Aircraft.new(Image.new("Bell P-39D.gif"), "Bell P-39D", allies, fighter, 2)
    @air6 = Aircraft.new(Image.new("Bell P-39D.gif"), "Bell P-39D", allies, fighter, 3)
    @air7 = Aircraft.new(Image.new("Dornier Do 26.gif"), "Dornier Do 26", axis, bomber, 1)
    @air8 = Aircraft.new(Image.new("Dornier Do 26.gif"), "Dornier Do 26", axis, bomber, 2)
    @air9 = Aircraft.new(Image.new("Dornier Do 26.gif"), "Dornier Do 26", axis, bomber, 3)
    @air10 = Aircraft.new(Image.new("Brewster F2A-3.gif"), "Brewster F2A-3", allies, fighter, 1)
    @air11 = Aircraft.new(Image.new("Brewster F2A-3.gif"), "Brewster F2A-3", allies, fighter, 2)
    @air12 = Aircraft.new(Image.new("Brewster F2A-3.gif"), "Brewster F2A-3", allies, fighter, 3)
    @air13 = Aircraft.new(Image.new("Curtiss P-40E.jpg"), "Curtiss P-40E", allies, fighter, 1)
    @air14 = Aircraft.new(Image.new("Curtiss P-40E.jpg"), "Curtiss P-40E", allies, fighter, 2)
    @air15 = Aircraft.new(Image.new("Curtiss P-40E.jpg"), "Curtiss P-40E", allies, fighter, 3)
    @air16 = Aircraft.new(Image.new("Messerschmitt ME-109"), "Messerschmitt ME-109", axis, fighter, 1)
    @air17 = Aircraft.new(Image.new("Messerschmitt ME-109"), "Messerschmitt ME-109", axis, fighter, 2)
    @air18 = Aircraft.new(Image.new("Messerschmitt ME-109"), "Messerschmitt ME-109", axis, fighter, 3)
    @air19 = Aircraft.new(Image.new("Vickers Wellington"), "Vickers Wellington", allies, bomber, 1)
    @air20 = Aircraft.new(Image.new("Vickers Wellington"), "Vickers Wellington", allies, bomber, 2)
    @air21 = Aircraft.new(Image.new("Vickers Wellington"), "Vickers Wellington", allies, bomber, 3)
    @keep1 = Keepem.new(Image.new("keepem.gif"), 1)
    @keep2 = Keepem.new(Image.new("keepem.gif"), 2)
    @keep3 = Keepem.new(Image.new("keepem.gif"), 3)
    @keep4 = Keepem.new(Image.new("keepem.gif"), 4)
    @keep5 = Keepem.new(Image.new("keepem.gif"), 5)
    @keep6 = Keepem.new(Image.new("keepem.gif"), 6)
    @vic1 = Victory.new(Image.new("victory.gif"))

    expected_attacks1 = Attack.new(Squadron.new([@air4, @air5, @air6]), Squadron.new([@air1, @air2, @air3]))
    expected_attacks2 = Attack.new(Squadron.new([@air10, @air11, @air12]), Squadron.new([@air1, @air2, @air3]))
    expected_attacks3 = Attack.new(Squadron.new([@air4, @air5, @air6]), Squadron.new([@air1, @air2, @air3]))

    @list_of_attacks1 = [expected_attacks1, expected_attacks2, expected_attacks3]
    @list_of_attacks2 = [expected_attacks3, expected_attacks1, expected_attacks2]
    @list_of_squads = [Squadron.new([@air1, @air2, @air3])]
  end

  def test_Ret_equal?
    test_ret1 = Ret.new(@list_of_attacks1, @list_of_squads, @air1)
    test_ret2 = Ret.new(@list_of_attacks2, @list_of_squads, @air6)
    test_ret3 = Ret.new(@list_of_attacks1, @list_of_squads, @air1)

    assert_same(test_ret1, test_ret1, "Ret.equal? Failed")
    assert_not_same(test_ret2, test_ret1, "Ret.equal? Failed")
    assert_same(test_ret1, test_ret3, "Ret.equal? Failed")
  end

  def test_End_equal?
    test_end1 = End.new(@list_of_attacks1, @list_of_squads, @air1)
    test_end2 = End.new(@list_of_attacks2, @list_of_squads, @air6)
    test_end3 = End.new(@list_of_attacks1, @list_of_squads, @air1)
    test_ret = Ret.new(@list_of_attacks2, @list_of_squads, @air6)

    assert_same(test_end1, test_end1, "End.equal? Failed")
    assert_not_same(test_end2, test_end1, "End.equal? Failed")
    assert_same(test_end1, test_end3, "End.equal? Failed")
    assert_not_same(test_end2, test_ret, "End.equal? Failed")
  end

  def test_End_nilcard_equal?
    test_end1 = End.new(@list_of_attacks1, @list_of_squads, nil)
    test_end2 = End.new(@list_of_attacks2, @list_of_squads, nil)
    test_end3 = End.new(@list_of_attacks1, @list_of_squads, nil)
    test_ret = Ret.new(@list_of_attacks1, @list_of_squads, @keep1)

    assert_same(test_end1, test_end1, "End.equal? Failed")
    assert_not_same(test_end2, test_end1, "End.equal? Failed")
    assert_same(test_end1, test_end3, "End.equal? Failed")
    assert_not_same(test_end2, test_ret, "End.equal? Failed")
  end

  def test_xml_to_done
    ret_doc = Document.new File.new("xmltests/ret_test.xml")
    end_doc = Document.new File.new("xmltests/end_test.xml")
    ret_test = Document.new "<RET><AIRCRAFT NAME=\"Bell P-39D\" TAG=\"2\" /><LIST /></RET>"
    
    expected_ret_test = Ret.new([], [], @air5)
    expected_ret = Ret.new(
      [Attack.new(Squadron.new([@air13, @air14, @air15]), Squadron.new([@air7, @air8, @air9])),
      Attack.new(Squadron.new([@air16, @air17, @air18]), Squadron.new([@air19, @air20, @air21]))],
      [Squadron.new([@air1, @air2, @air3]), Squadron.new([@air4, @air5, @air6])], @vic1)
    expected_end = End.new(
      [Attack.new(Squadron.new([@air13, @air14, @air15]), Squadron.new([@air7, @air8, @air9])),
      Attack.new(Squadron.new([@air16, @air17, @air18]), Squadron.new([@air19, @air20, @air21]))],
      [Squadron.new([@air1, @air2, @air3]), Squadron.new([@air4, @air5, @air6])], nil)

    assert_same(expected_ret_test, Done.xml_to_done(ret_test))
    assert_same(expected_ret, Done.xml_to_done(ret_doc))
    assert_same(expected_end, Done.xml_to_done(end_doc))
  end

  def test_ret_to_xml
    list_of_discards = [Squadron.new([@air1, @air2, @air3]), Squadron.new([@air4, @air5, @air6])]
    list_of_attacks = [Attack.new(Squadron.new([@air13, @air14, @air15]), Squadron.new([@air7, @air8, @air9])),   
      Attack.new(Squadron.new([@air16, @air17, @air18]), Squadron.new([@air19, @air20, @air21]))]
    
    document = Document.new
    ret = document.add_element "RET"
    ret.add_element @vic1.card_to_xml
    slst = ret.add_element "LIST"
    list_of_discards.each{|squadron|
      squadron = slst.add_element squadron.squadron_to_xml
    }
    list_of_attacks.each{|attack|
      atck = ret.add_element attack.attack_to_xml
    } 

    ret_test = Ret.new(list_of_attacks, list_of_discards, @vic1)

    assert_equal(document.to_s, ret_test.done_to_xml.to_s)
  end

  def test_end_to_xml
    list_of_discards = [Squadron.new([@air1, @air2, @air3]), Squadron.new([@air4, @air5, @air6])]
    list_of_attacks = [Attack.new(Squadron.new([@air13, @air14, @air15]), Squadron.new([@air7, @air8, @air9])),   
      Attack.new(Squadron.new([@air16, @air17, @air18]), Squadron.new([@air19, @air20, @air21]))]
    
    document = Document.new
    ed = document.add_element "END"
    ed.add_element @vic1.card_to_xml
    slst = ed.add_element "LIST"
    list_of_discards.each{|squadron|
      squadron = slst.add_element squadron.squadron_to_xml
    }
    list_of_attacks.each{|attack|
      atck = ed.add_element attack.attack_to_xml
    } 

    end_test = End.new(list_of_attacks, list_of_discards, @vic1)

    assert_equal(document.to_s, end_test.done_to_xml.to_s)
  end
  
  def test_end_to_xml_no_card
    list_of_discards = [Squadron.new([@air1, @air2, @air3]), Squadron.new([@air4, @air5, @air6])]
    list_of_attacks = [Attack.new(Squadron.new([@air13, @air14, @air15]), Squadron.new([@air7, @air8, @air9])),   
      Attack.new(Squadron.new([@air16, @air17, @air18]), Squadron.new([@air19, @air20, @air21]))]
    
    document = Document.new
    ed = document.add_element "END"
    ed.add_element "FALSE"
    slst = ed.add_element "LIST"
    list_of_discards.each{|squadron|
      squadron = slst.add_element squadron.squadron_to_xml
    }
    list_of_attacks.each{|attack|
      atck = ed.add_element attack.attack_to_xml
    } 

    end_test = End.new(list_of_attacks, list_of_discards, nil)

    assert_equal(document.to_s, end_test.done_to_xml.to_s)
  end
end
