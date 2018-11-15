//
//  HASuggestionField.swift
//  HASuggestionField
//
//  Created by Hassan Aftab on 06/11/2017.
//  Copyright © 2017 app. All rights reserved.
//

import UIKit

public typealias HASymbol = Character

/// Value contains list of items and other useful attibutes for storing against a symbol
public struct HASuggestionFieldValue {
    
    /// Symbol against which items of this `HASuggestionFieldValue` will be suggested 
    public var symbol = HASymbol("")
    
    /// attributes applied to word when a suggestion is selected
    public var attributesWhenSelected = [NSAttributedStringKey: Any]()
    
    /// list of items shown in dropdown when the attached symbol will be pressed
    public var items = [HASuggestionFieldItem]()
    
    /// will detect symbol only first time
    public var isUnique = false
    
    /// any value that starts with given symbol will be treated as correct value
    public var setAny = false 
    
    fileprivate func containesWord(_ word: String) -> Bool {
        
        for item in items {
            if item.replaceDetail && word == item.detail {
                return true
            }
            if word == item.title {
                return true
            }
        }
        return false
    }
    fileprivate func getItemForWord(_ word: String) -> HASuggestionFieldItem? {
        for item in items {
            if item.replaceDetail && word == item.detail {
                return item
            }
            if word == item.title {
                return item
            }
        }
        return nil
    }
    public init(symbol: HASymbol, attributesWhenSelected: [NSAttributedStringKey: Any]! = [:], items: [HASuggestionFieldItem]! = [], isUnique: Bool = false, setAny: Bool = false) {
        self.symbol = symbol
        self.attributesWhenSelected = attributesWhenSelected ?? [:]
        self.items = items
        self.isUnique = isUnique
        self.setAny = setAny
    }
}

public struct HASuggestionFieldItem {
    
    
    public var title = ""
    public var detail = ""
    
    /// if image to be displayed with item in suggestion dropdown
    public var image : UIImage! = UIImage()
    
    /// if `image` is nil, suggestion dropdown will try to get image from url
    public var imgURL : String! = ""
    
    /// if true, it will replace written text with detail, if false it will be replaced by value
    public var replaceDetail = false 
    
    public init(title: String = "", detail: String = "", image: UIImage! = nil, imgURL: String! = nil, replaceDetail: Bool = false) {
        self.title = title
        self.detail = detail
        self.image = image
        self.imgURL = imgURL
        self.replaceDetail = replaceDetail
    }
}

@objc public protocol HASuggestionFieldDelegate {
    func haSuggestionField(_ field: HASuggestionField, didChangeTextfor symbol:String, word: String)
    @objc optional func haSuggestionField(_ field: HASuggestionField, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    @objc optional func haSuggestionField(_ field: HASuggestionField, didEnter symbol: String)
}

public class HASuggestionField: UITextView {
    
    private var valuesForSymbols = [HASymbol: HASuggestionFieldValue]()
    private var suggestionDropDown = HASuggestionDropDown()
    private var selectedKeyRange = NSRange()
    
    private var placeholderText = ""
    var suggestionDelegate : HASuggestionFieldDelegate?
    
    private var keys : [HASymbol] {
        var keys = [HASymbol]()
        
        for (key, _) in valuesForSymbols {
            keys.append(key)
        }
        return keys
    }
    
    
    var placeholder : String {
        set {
            placeholderText = newValue
            placeholderLabel.removeFromSuperview()
            placeholderLabel.frame = CGRect(x: 8, y: 8, width: self.bounds.width-16, height: 0)
            placeholderLabel.textColor = placeholderColor
            placeholderLabel.lineBreakMode = .byWordWrapping
            placeholderLabel.font = self.font
            placeholderLabel.alpha = 0
            placeholderLabel.text = newValue
            placeholderLabel.sizeToFit()
            self.sendSubview(toBack: placeholderLabel)
            
            self.addSubview(placeholderLabel)
            
            if self.text.count == 0 && newValue.count > 0 {
                placeholderLabel.alpha = 1
            }
        }
        get {
            return placeholderText
        }
    }
    
    private let placeholderColor = UIColor.lightGray
    private var placeholderLabel = UILabel()
    
    override public var delegate: UITextViewDelegate? {
        get {
            return super.delegate
        }
        set {
            super.delegate = newValue
        }
    }
    
    override public func draw(_ rect: CGRect) {
        super.draw(rect)
        
        
        self.delegate = self
        suggestionDropDown.delegate = self
    }
    
    public func setupWithValues(_ values:[HASuggestionFieldValue]) {
        for value in values {
            self.addValue(value)
        }
    }
    
    public func removeValue(for symbol: HASymbol) {
        valuesForSymbols[symbol] = nil
    }
    
    func addValue(_ value: HASuggestionFieldValue) {
        
        guard !String(value.symbol).isEmpty else {
            return
        }
        
        valuesForSymbols[value.symbol] = value
    }
    
    private func updatingtWord()-> String {
        let text = self.attributedText.string as NSString
        
        let subString = text.substring(to: selectedRange.location)
        
        
        let startToCursor = String(subString)
        
        let updatingWord = (startToCursor.components(separatedBy: CharacterSet.whitespacesAndNewlines).last)!
        
        return updatingWord 
    }
    
    private func updatingtWordRange()-> Range<String.Index> {
        let text = self.attributedText.string as NSString
        let subString = text.substring(to: selectedRange.location)
        
        
        let startToCursor = String(subString)
        
        let updatingWord = (startToCursor.components(separatedBy: " ").last)!
        
        if let lastRange = subString.ranges(of: updatingWord).last {
            return lastRange
        }
        
        return subString.range(of: updatingWord)!
    }
    
    @objc private func applyAttributes() {
        let words = self.text.components(separatedBy: " ")
        
        let attributedString = NSMutableAttributedString()
        
        for word in words {
            if let value = valuesForSymbols[HASymbol(String(word.prefix(1)))] {
                
                let attributeSubString = NSMutableAttributedString(string: word, attributes: value.attributesWhenSelected)
                if !value.containesWord(String(word.dropFirst())) && !value.setAny {
                    
                    attributeSubString.setAttributes(nil, range: NSRange(location: 0, length: attributeSubString.string.count))
                }
                
                
                attributedString.append(attributeSubString)
            }
            else {
                let attributeSubString = NSAttributedString(string: word)
                
                attributedString.append(attributeSubString)
            }
            if words.last != word {
                attributedString.append(NSAttributedString(string: " ",attributes: [NSAttributedStringKey.foregroundColor:UIColor.black]))
            }
            
        }
        
        self.attributedText = attributedString
        
        
    }
    
    fileprivate func closeDropDown() {
        suggestionDropDown.collapseTableView()
        suggestionDropDown = HASuggestionDropDown()
        suggestionDropDown.delegate = self
        self.typingAttributes = [String:Any]()
    }
    
}

extension HASuggestionField: UITextViewDelegate {
    internal func textViewDidChange(_ textView: UITextView) {
        
        if textView.text.count == 0 && placeholder.count > 0 {
            placeholderLabel.alpha = 1
            placeholderLabel.text = placeholder
        }
        else {
            placeholderLabel.alpha = 0
            placeholderLabel.text = ""
            if textView.text.last == " " {
                applyAttributes()
            }
        }
        
        let keyToFind = updatingtWord() 
        
        var key : HASymbol!
        
        for key1 in keys {
            if keyToFind.hasPrefix(String(key1)) {
                key = key1
                break
            }
        }
        
        
        if key != nil && String(key) != "" {
            
            if let val = valuesForSymbols[key] {
                
                if val.isUnique {
                    let words = self.text.components(separatedBy: CharacterSet.whitespacesAndNewlines)
                    for word in words {
                        if let value = valuesForSymbols[key] {
                            if value.containesWord(String(word.dropFirst(1))) {
                                return
                            }
                        }
                    }
                    
                }
                
                
                let vals = val.items
                let queryStr = keyToFind.dropFirst()
                
                suggestionDelegate?.haSuggestionField?(self, didEnter: String(key))
                suggestionDelegate?.haSuggestionField(self, didChangeTextfor: String(key), word: String(queryStr))
                
                var vals2 = vals
                
                vals2 = vals.filter({ (item) -> Bool in
                    return item.title.contains(queryStr)
                })
                
                suggestionDropDown.symbol = String(key)
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
                
                closeDropDown()
            }
        }
        else {
            closeDropDown()
        }
        self.typingAttributes = [String:Any]()        
        
    }
    
    internal func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return suggestionDelegate?.haSuggestionField?(self, shouldChangeTextIn: range, replacementText: text) ?? true
    }
}

extension HASuggestionField: HASuggestionDropDownDelegate {
    public func haSuggestionDropDown(_ dropDown: HASuggestionDropDown, didSelect item: HASuggestionFieldItem, at index: Int) {
        guard let symbol = updatingtWord().first else {
            return
        }
        if item.replaceDetail {
            var str = self.text
            str?.replaceSubrange(updatingtWordRange(), with: String(symbol) + item.detail)
            
            self.text = str!
        }
        else {
            self.text.replaceSubrange(updatingtWordRange(), with: String(symbol) + item.title)
        }
        
        applyAttributes()
        
    }
    
    
}

public protocol HASuggestionDropDownDelegate {
    func haSuggestionDropDown(_ dropDown: HASuggestionDropDown, didSelect item: HASuggestionFieldItem, at index: Int)
}

public class HASuggestionDropDown: UITableViewController {
    
    var itemHeight : CGFloat = 41.0
    
    var tableFrame : CGRect!
    
    
    var valueFont = UIFont.systemFont(ofSize: 15)
    var detailFont = UIFont.systemFont(ofSize: 12)
    
    var valueColor = UIColor.black
    var detailColor = UIColor.darkGray
    
    var items = [HASuggestionFieldItem]()
    var delegate : HASuggestionDropDownDelegate!
    
    var suggestionField : UIView!
    var rootView : UIView!
    
    var symbol = ""
    
    var showFooter = false
    
    private var tapGestureBackground: UITapGestureRecognizer!
    
    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func imageFromUrl(_ urlString: String, onLoaded: @escaping ((UIImage?)->Void)) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            URLSession.shared.dataTask(with: request) {(data,response,error) in
                if let imageData = data as Data? {
                    if let img = UIImage(data: imageData){
                        onLoaded(self.imageWithImage(image: img, scaledToSize: CGSize(width: 35, height: 35)))
                    }
                    else {
                        onLoaded(nil)
                    }
                }
                else {
                    onLoaded(nil)
                }
                }.resume()
        }
    }
    
    func imageWithImage(image:UIImage,scaledToSize newSize:CGSize)->UIImage{
        
        UIGraphicsBeginImageContext( newSize )
        image.draw(in: CGRect(x: 0,y: 0,width: newSize.width,height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    
    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "simpleCell")
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: "simpleCell")
        }
        if items.count <= indexPath.row {
            return cell!
        }
        let item = items[indexPath.row]
        
        cell?.textLabel?.font = valueFont
        cell?.detailTextLabel?.font = detailFont
        
        cell?.textLabel?.textColor = valueColor
        cell?.detailTextLabel?.textColor = detailColor
        
        if item.image == nil && item.imgURL != nil {
            imageFromUrl(item.imgURL, onLoaded: { (image) in
                if image != nil {
                    DispatchQueue.main.async {
                        
                        cell?.imageView?.image = image
                        
                        if indexPath.row < self.items.count {
                            self.items[indexPath.row].image = image
                            self.tableView.reloadRows(at: [indexPath], with: .automatic)
                        }
                        
                        
                        cell?.layoutIfNeeded()
                    }
                }
            })
        }
        else {
            cell?.imageView?.image = item.image
        }
        cell?.imageView?.layer.cornerRadius = 5
        
        let title = symbol + item.title
        cell?.textLabel?.text = title
        cell?.detailTextLabel?.text = item.detail
        cell?.textLabel?.frame = UIEdgeInsetsInsetRect((cell?.textLabel?.frame)!, UIEdgeInsetsMake(0, 16, 0, 16))
        return cell!
    }
    
    override public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if delegate != nil {
            delegate.haSuggestionDropDown(self, didSelect: items[indexPath.row], at: indexPath.row)
        }
        collapseTableView()
        
    }
    
    override public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return itemHeight
    }
    
    
    
    func show(for view: UIView) {
        
        
        self.view.layer.zPosition = 100
        self.view.layer.borderColor = UIColor.lightGray.cgColor
        self.view.layer.borderWidth = 1
        self.view.layer.cornerRadius = 4
        
        
        self.suggestionField = view
        
        UIApplication.shared.keyWindow?.addSubview(self.view)
        self.rootView = UIApplication.shared.keyWindow
        
        resizeTableView()
        
        self.tableView.reloadData()
    }
    
    @objc func backgroundTaped() {
        collapseTableView()
    }
    
    func resizeTableView() {
        guard let rootView = self.rootView  else {
            return
        }
        guard let _ = self.suggestionField  else {
            return
        }
        
        var newFrame: CGRect = (suggestionField.superview!.convert(suggestionField.frame, to: rootView))
        let height : CGFloat = CGFloat(items.count > 3 ? itemHeight*3 : itemHeight*CGFloat(items.count))
        
        let previousHeight = self.view.frame.height
        
        var y = newFrame.origin.y
        
        if newFrame.origin.y > rootView.frame.height/2 {
            y = newFrame.origin.y - suggestionField.frame.height - 10 - height // if suggestion field is low on the screen show dropdown above the field
        }
        newFrame.origin.y = y// = CGPoint(newFrame.origin.x, y)
        self.tableFrame = newFrame
        
        self.view.frame = CGRect(x: self.tableFrame.origin.x, y: self.tableFrame.origin.y + suggestionField.frame.height+5, width: suggestionField.frame.width, height: previousHeight);
        
        
        UIView.animate(withDuration: 0.25, animations: { 
            self.view.frame = CGRect(x: self.tableFrame.origin.x, y: self.tableFrame.origin.y + self.suggestionField.frame.height+5, width: self.suggestionField.frame.width, height: height)
            self.view.layoutIfNeeded()
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
    private func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        collapseTableView()
    }
    
}


extension String {
    public func ranges(of searchString: String, options: CompareOptions = [], searchRange: Range<Index>? = nil ) -> [Range<Index>] {
        if let range = range(of: searchString, options: options, range: searchRange, locale: nil) {
            
            let nextRange = range.upperBound..<(searchRange?.upperBound ?? endIndex)
            return [range] + ranges(of: searchString, searchRange: nextRange)
        } else {
            return []
        }
    }
}

