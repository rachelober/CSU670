# !/arch/unix/bin/ruby

# xmlhelper.rb
# Used to help parse xml into objects
# and to turn objects into valid xml

class XMLHelper
  # ----------------------------------------
  # Converting XML into Objects
  # ----------------------------------------

  # XMLHelper.xml_okay? : Document -> Boolean
  def XMLHelper.xml_okay?(xml)
    root = xml.root
    root.name == 'OKAY'
  end
   
  # ----------------------------------------
  # Converting Objects into XML
  # ----------------------------------------

  # XMLHelper.boolean_to_xml : Boolean -> String
  #
  # Converts a Boolean into an XML String.
  def XMLHelper.boolean_to_xml(boolean)
    if boolean
      bool = Document.new
      bool.add_element "TRUE"
    else
      bool = Document.new
      bool.add_element "FALSE"
    end
  end

  # XMLHelper.parse_test_case : Document -> Document Document Document
  #
  # Parses through a test case and separates it into a fsth, turn, and done.
  def XMLHelper.parse_test_case(doc)
    root = doc.root
    fsth = root.elements[1].to_s
    borc = root.elements[2]
    if XPath.match(borc, "//FALSE")
      bool = Document.new
      bool.add_element "FALSE"
    else
      bool = Document.new
      bool.add_element "TRUE"
    end
    stck = root.elements[3]
    slst_axis = root.elements[4]
    slst_allies = root.elements[5]
    done = root.elements[6]

    document = Document.new
    turn = document.add_element "TURN"
    turn.add_element bool
    turn.add_element stck
    turn.add_element slst_axis
    turn.add_element slst_allies

    return fsth, turn, done
  end
end
