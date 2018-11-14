//
//  ViewController.swift
//  HASuggestionField
//
//  Created by Hassan Aftab on 06/11/2017.
//  Copyright © 2017 app. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet weak var suggestionField: HASuggestionField!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
        
	}

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
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}
extension ViewController: HASuggestionFieldDelegate {
    func haSuggestionField(_ field: HASuggestionField, didChangeTextfor symbol: String, word: String) {
        print("User entered \(word) for symbol \(symbol)")
    }
    
    func haSuggestionField(_ field: HASuggestionField, didEnter symbol: String) {
        print("User entered the symbol \(symbol)")
    }
    
}

