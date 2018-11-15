//
//  HASuggestionField.swift
//  HASuggestionField
//
//  Created by Hassan Aftab on 06/11/2017.
//  Copyright © 2017 app. All rights reserved.
//

import UIKit

typealias HASymbol = String

struct HASuggestionFieldValue {
	var attributesWhenSelected = [NSAttributedStringKey: Any]()
	var items = [HASuggestionFieldItem]()
	
	func containesWord(_ word: String) -> Bool {
		for item in items {
			if word == item.value {
				return true
			}
		}
		return false
	}
}

struct HASuggestionFieldItem {
	var value = ""
	var detail = ""
	var image = UIImage()
	
	
}

class HASuggestionField: UITextView {

	var valuesForSymbols = [HASymbol: HASuggestionFieldValue/*[HASuggestionFieldItem]*/]()
	var suggestionDropDown = HASuggestionDropDown()
	private var selectedKeyRange = NSRange()
	
	
	override func awakeFromNib() {
		super.awakeFromNib()
		self.delegate = self
		
		let atVals = [
			HASuggestionFieldItem(value: "Hassan", detail: "Aftab", image: UIImage()),
			HASuggestionFieldItem(value: "Zain", detail: "Sidhu", image: UIImage()),
			HASuggestionFieldItem(value: "Mohsin", detail: "Naeem", image: UIImage()),
			HASuggestionFieldItem(value: "Tayyab", detail: "Khalid", image: UIImage()),
			HASuggestionFieldItem(value: "Junaid", detail: "Sidhu", image: UIImage())
		]
		
		
		
		let value = HASuggestionFieldValue(attributesWhenSelected: [NSAttributedStringKey.foregroundColor: UIColor.blue], items: atVals)
		
		valuesForSymbols["@"] = value
		suggestionDropDown.delegate = self
		
	}
	
	private func updatingtWord()-> String {
		let text = self.attributedText.string
		let idx = text.index((text.startIndex), offsetBy: selectedRange.location) 
		
		let subString = text[(text.startIndex)..<idx]
		
		let startToCursor = String(subString)
		
		let updatingWord = (startToCursor.components(separatedBy: " ").last)!
		
		
		return updatingWord
	}
	
	private func updatingWordRange() -> Range<String.Index> {
		let text = self.attributedText.string
		let idx = text.index((text.startIndex), offsetBy: selectedRange.location) 
		
		let subString = text[(text.startIndex)..<idx]
		
		let startToCursor = String(subString)
		
		let updatingWord = (startToCursor.components(separatedBy: " ").last)!
		
		let startIdx = text.index((text.startIndex), offsetBy: (startToCursor.count-updatingWord.count+1)) // +1 to remove symbol of suggestion
		
		return startIdx..<idx
	}
	
	func applyAttributes() {
		let words = self.text.components(separatedBy: " ")
		
		let attributedString = NSMutableAttributedString()
		
		for word in words {
			if let value = valuesForSymbols[String(word.prefix(1))] {
				
				let attributeSubString = NSMutableAttributedString(string: word, attributes: value.attributesWhenSelected)
				if !value.containesWord(String(word.dropFirst())) {
					
					attributeSubString.setAttributes(nil, range: NSRange(location: 0, length: attributeSubString.string.count))
				}
				
				
				attributedString.append(attributeSubString)
			}
			else {
				let attributeSubString = NSAttributedString(string: word)
				
				attributedString.append(attributeSubString)
			}
			attributedString.append(NSAttributedString(string: " "))
		}
		
		self.attributedText = attributedString
		
		
	}
	
}

extension HASuggestionField: UITextViewDelegate {
	func textViewDidChange(_ textView: UITextView) {

		let keyToFind = updatingtWord() 
		
		if let key = keyToFind.first {
			if let val = valuesForSymbols["\(key)"] {
				
				let vals = val.items
				let queryStr = keyToFind.dropFirst()
				let vals2 = vals.filter({ (item) -> Bool in
					return item.value.contains(queryStr)
				})
				
				suggestionDropDown.items = vals2
				
				if vals2.count == 0 && keyToFind.count == 1 {
					suggestionDropDown.items = vals
				}
				
				if suggestionDropDown.view.superview == nil {
					suggestionDropDown.show(for: self)
				}
				else {
					suggestionDropDown.resizeTableView()
					suggestionDropDown.tableView.reloadData()
				}
			}
			else {
				suggestionDropDown.collapseTableView()
				self.typingAttributes = [String:Any]()
			}
		}
		else {
			suggestionDropDown.collapseTableView()
			self.typingAttributes = [String:Any]()
		}
		
		
	}
}

extension HASuggestionField: HASuggestionDropDownDelegate {
	func haSuggestionDropDown(_ dropDown: HASuggestionDropDown, didSelect item: HASuggestionFieldItem, at index: Int) {
//		let updateRange = updatingWordRange()
		
		self.text.replaceSubrange(updatingWordRange(), with: item.value)
		
		applyAttributes()
		
//		self.attributedText.
		
	}
	
	
}

protocol HASuggestionDropDownDelegate {
	func haSuggestionDropDown(_ dropDown: HASuggestionDropDown, didSelect item: HASuggestionFieldItem, at index: Int)
}

class HASuggestionDropDown: UITableViewController {
	
	var itemHeight = 41.0
	
	var tableFrame : CGRect!
	
	
	var valueFont = UIFont.systemFont(ofSize: 15)
	var detailFont = UIFont.systemFont(ofSize: 12)
	
	var valueColor = UIColor.black
	var detailColor = UIColor.darkGray
	
	var items = [HASuggestionFieldItem]()
	var delegate : HASuggestionDropDownDelegate!
	
	var suggestionField : HASuggestionField!
	var rootView : UIView!
	
		
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return items.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let item = items[indexPath.row]
		
		var cell = tableView.dequeueReusableCell(withIdentifier: "simpleCell")
		if cell == nil {
			cell = UITableViewCell(style: .value1, reuseIdentifier: "simpleCell")
		}
		
		cell?.textLabel?.font = valueFont
		cell?.detailTextLabel?.font = detailFont
		
		cell?.textLabel?.textColor = valueColor
		cell?.detailTextLabel?.textColor = detailColor
		
		cell?.imageView?.image = item.image
		cell?.imageView?.layer.cornerRadius = 5
		
		cell?.textLabel?.text = item.value
		cell?.detailTextLabel?.text = item.detail
		
		return cell!
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		
		if delegate != nil {
			delegate.haSuggestionDropDown(self, didSelect: items[indexPath.row], at: indexPath.row)
		}
		collapseTableView()
		
	}
	
	func show(for view: UIView) {
		
		
		self.view.layer.zPosition = 1
		self.view.layer.borderColor = UIColor.lightGray.cgColor
		self.view.layer.borderWidth = 1
		self.view.layer.cornerRadius = 4
		
		self.suggestionField = view as! HASuggestionField
		
		rootView = view.superview
		
		if self.view.superview != nil {
			self.view.removeFromSuperview()
		}
		
		// adding tableview to root view( we can say first view in hierarchy)
		while rootView?.superview != nil && !(rootView?.superview?.traverseResponderChainForUIViewController() is UIViewController) {
			rootView = rootView?.superview!
		}
		
		rootView?.addSubview(self.view)
		
		resizeTableView()
		
		self.tableView.reloadData()
	}
	
	func resizeTableView() {
		guard let rootView = self.rootView  else {
			return
		}
		guard let _ = self.suggestionField  else {
			return
		}
		
		let newFrame: CGRect = (suggestionField.superview!.convert(suggestionField.frame, to: rootView))
		let height : CGFloat = CGFloat(items.count > 5 ? itemHeight*5 : itemHeight*Double(items.count))
		
		self.tableFrame = newFrame
		
		self.view.frame = CGRect(x: self.tableFrame.origin.x, y: self.tableFrame.origin.y + suggestionField.frame.height+5, width: suggestionField.frame.width, height: 0);
		
		
		UIView.animate(withDuration: 0.25, animations: { 
			self.view.frame = CGRect(x: self.tableFrame.origin.x, y: self.tableFrame.origin.y + self.suggestionField.frame.height+5, width: self.suggestionField.frame.width, height: height)
			
		})
	}
	
	func collapseTableView() {
		self.view.removeFromSuperview()
	}
	
	
}



extension UIResponder {
	func traverseResponderChainForUIViewController() -> AnyObject? {
		let nextResponder = self.next
		if nextResponder is UIViewController {
			return nextResponder
		}
		else if nextResponder is UIView {
			return nextResponder?.traverseResponderChainForUIViewController()
		}
		else {
			return nil
		}
	}
}


extension HASuggestionDropDown: UINavigationControllerDelegate {
	func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
		collapseTableView()
	}
	
}




