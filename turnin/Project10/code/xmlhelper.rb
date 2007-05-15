# !/arch/unix/bin/ruby

# xmlhelper.rb
# Used to help parse xml into objects
# and to turn objects into valid xml

# required files
require 'rexml/document'
include REXML

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
      return "<TRUE />"
    else
      return "<FALSE />"
    end
  end

  # XMLHelper.parse_test_case : Document -> String String String
  #
  # Parses through a test case and separates it into a fsth, turn, and done.
  def XMLHelper.parse_test_case(doc)
    root = doc.root
    fsth = root.elements[1].to_s
    borc = root.elements[2]
    if XPath.match(borc, "//FALSE")
      bool = "<FALSE />"
    else
      bool = "<TRUE />"
    end
    stck = root.elements[3].to_s
    slst_axis = root.elements[4].to_s
    slst_allies = root.elements[5].to_s
    done = root.elements[6].to_s

    turn = "<TURN>" + bool + stck + slst_axis + slst_allies + "</TURN>"
    
    return fsth, turn, done
  end
end
