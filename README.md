# HASuggestionField
HASuggestionField is a iOS suggestion list written in Swift. It suggests list of items provided against any symbol. It allows user to select any of the suggested item from dropdown. Then it applies provided attributes on selected item. 
Items are also defined by structs. These structs will define each item's properties. 
![Alt text](https://github.com/Hassan-Aftab/HASuggestionField/blob/master/Screen%20Shot.png?raw=true "Demo")

Simply include HASuggestionField.swift in your project. 
# Usage

Create a HASuggestionField in IB or in code (using UIView's init methods). Then add values for suggestion field, for example:
```javascript
    @IBOutlet weak var suggestionField: HASuggestionField!
    
    
    func setupSuggestionFieldData() {
        let usersValue = HASuggestionFieldValue
            .init(symbol: HASymbol("@"),
                  attributesWhenSelected: [NSAttributedString.Key.foregroundColor: UIColor.blue], 
                  items: getSomeUsers(), 
                  isUnique: false, 
                  setAny: false)
        
        let tagsValue = HASuggestionFieldValue
            .init(symbol: HASymbol("#"), 
                  attributesWhenSelected: [NSAttributedString.Key.backgroundColor : UIColor.lightGray], 
                  items: getSomeHastags(), 
                  isUnique: false, 
                  setAny: true)
        
        suggestionField.setupWithValues([tagsValue, usersValue])
    }
    
	func getSomeUsers() -> [HASuggestionFieldItem] {
		
		let user1 = HASuggestionFieldItem.init(title: "Hassan", detail: "Hassanpro43@gmail.com", image: nil, imgURL: nil, replaceDetail: false)
		
		let user2 = HASuggestionFieldItem.init(title: "John", detail: "someJohn@gmail.com", image: nil, imgURL: nil, replaceDetail: false)
		
		let user3 = HASuggestionFieldItem.init(title: "Jack", detail: "someJack@gmail.com", image: nil, imgURL: nil, replaceDetail: false)
		
		let user4 = HASuggestionFieldItem.init(title: "Tyrion", detail: "tyrion@gmail.com", image: nil, imgURL: nil, replaceDetail: false)
		
		return [user1, user2, user3, user4]
	}
	
	func getSomeHastags() -> [HASuggestionFieldItem] {
		let tag1 = HASuggestionFieldItem.init(title: "developer", detail: "", image: nil, imgURL: nil, replaceDetail: false)
		
		let tag2 = HASuggestionFieldItem.init(title: "coder", detail: "", image: nil, imgURL: nil, replaceDetail: false)
		
		let tag3 = HASuggestionFieldItem.init(title: "swift", detail: "", image: nil, imgURL: nil, replaceDetail: false)
		
		let tag4 = HASuggestionFieldItem.init(title: "ios", detail: "", image: nil, imgURL: nil, replaceDetail: false)
		
		return [tag1, tag2, tag3, tag4]
	}

```

You can also implement HASuggestionFieldDelegate to get notified when user enters a symbol or some text against a symbol:

```javascript
    func haSuggestionField(_ field: HASuggestionField, didChangeTextfor symbol: String, word: String) {
        print("User entered \(word) for symbol \(symbol)")
    }
    
    func haSuggestionField(_ field: HASuggestionField, didEnter symbol: String) {
        print("User entered the symbol \(symbol)")
    }
    
```

Values can be added or removed

All properties can be manually modified.

# License and Authorship

Released under the GNU GENERAL PUBLIC LICENSE. Copyright Hassan Aftab. Please open issues on GitHub.
