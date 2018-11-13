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
		
		let usersValue = HASuggestionFieldValue.init(attributesWhenSelected: [NSAttributedString.Key.foregroundColor: UIColor.blue], items: getSomeUsers(), isUnique: false, setAny: false)
		
		let tagsValue = HASuggestionFieldValue.init(attributesWhenSelected: [NSAttributedString.Key.backgroundColor : UIColor.lightGray], items: getSomeHastags(), isUnique: false, setAny: true)
		
		suggestionField.valuesForSymbols = ["@": usersValue,
											"#": tagsValue]
		
	}

	func getSomeUsers() -> [HASuggestionFieldItem] {
		
		let user1 = HASuggestionFieldItem.init(value: "Hassan", detail: "Hassanpro43@gmail.com", image: nil, imgURL: nil, formatSecret: "", secret: nil, replaceDetail: false)
		
		let user2 = HASuggestionFieldItem.init(value: "John", detail: "someJohn@gmail.com", image: nil, imgURL: nil, formatSecret: "", secret: nil, replaceDetail: false)
		
		let user3 = HASuggestionFieldItem.init(value: "Jack", detail: "someJack@gmail.com", image: nil, imgURL: nil, formatSecret: "", secret: nil, replaceDetail: false)
		
		let user4 = HASuggestionFieldItem.init(value: "Tyrion", detail: "tyrion@gmail.com", image: nil, imgURL: nil, formatSecret: "", secret: nil, replaceDetail: false)
		
		return [user1, user2, user3, user4]
	}
	
	func getSomeHastags() -> [HASuggestionFieldItem] {
		let tag1 = HASuggestionFieldItem.init(value: "developer", detail: "", image: nil, imgURL: nil, formatSecret: "", secret: nil, replaceDetail: false)
		
		let tag2 = HASuggestionFieldItem.init(value: "coder", detail: "", image: nil, imgURL: nil, formatSecret: "", secret: nil, replaceDetail: false)
		
		let tag3 = HASuggestionFieldItem.init(value: "champion", detail: "", image: nil, imgURL: nil, formatSecret: "", secret: nil, replaceDetail: false)
		
		let tag4 = HASuggestionFieldItem.init(value: "ios", detail: "", image: nil, imgURL: nil, formatSecret: "", secret: nil, replaceDetail: false)
		
		return [tag1, tag2, tag3, tag4]
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

