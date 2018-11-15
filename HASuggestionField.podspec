Pod::Spec.new do |s|

  s.swift_version = '4.0'
  s.name         = "HASuggestionField"
  s.version      = "0.0.1"
  s.summary      = "HASuggestionField is a iOS suggestion list written in Swift. It suggests list of items provided against any symbol. It allows user to select any of the suggested item from dropdown. Then it applies provided attributes on selected item. Items are also defined by structs. These structs will define each item's properties."

  s.ios.deployment_target = '8.0'

  s.xcconfig = { "OTHER_LDFLAGS" => "-lz" }
  s.homepage     = "https://github.com/Hassan-Aftab/HASuggestionField"

  s.license      = "GNU General Public License"


  s.author             = { "Hassan Aftab" => "Hassan.aftab@coeus-solutions.de" }

  s.source       = { :git => "https://github.com/Hassan-Aftab/HASuggestionField.git", :tag => "master" }


  s.source_files  = "Classes", "HASuggestionField/HASuggestionField/HASuggestionField.swift"

end
