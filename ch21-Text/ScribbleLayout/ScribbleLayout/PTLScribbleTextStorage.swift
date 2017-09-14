//
//  PTLScribbleTextStorage.swift
//  ScribbleLayout
//
//  Created by wj on 15/11/26.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit

struct PTLDefault{
    static let  TokenName = "PTLDefaultTokenName"
    static let  RedactStyleAttributeName = "PTLRedactStyleAttributeName"
    static let  HighlightColorAttributeName = "PTLHighlightColorAttributeName"
}


class PTLScribbleTextStorage: NSTextStorage {
    var backingStore = NSMutableAttributedString()
    var dynamicTextNeedsUpdate = false
    
    var tokens = [String:Any]()
    
    override var string:String{
        get{
            return  backingStore.string
        }
    }
    
    override func attributes(at location: Int, effectiveRange range: NSRangePointer?) -> [String : Any] {
        return backingStore.attributes(at: location, effectiveRange: range)
    }
    
    override func replaceCharacters(in range: NSRange, with str: String) {
        beginEditing()
        backingStore.replaceCharacters(in: range , with: str)
        edited([.editedAttributes,.editedCharacters], range: range, changeInLength: (str as NSString).length-range.length)
        dynamicTextNeedsUpdate = true
        endEditing()
    }
    
    override func setAttributes(_ attrs: [String : Any]?, range: NSRange) {
        beginEditing()
        backingStore.setAttributes(attrs, range: range)
        edited([.editedAttributes], range: range, changeInLength: 0)
        endEditing()
    }
    
    override func processEditing() {
        if self.dynamicTextNeedsUpdate{
            self.dynamicTextNeedsUpdate = true
            performReplacementsForCharacterChangeInRange(editedRange)
        }
        super.processEditing()
    }
    
    func performReplacementsForCharacterChangeInRange(_ changedRange:NSRange){
        let string = backingStore.string
        let startLine = NSMakeRange(changedRange.location, 0)
        let endLine =   NSMakeRange(NSMaxRange(changedRange), 0)
        var extendedRange  = NSUnionRange(changedRange,  (string as NSString).lineRange(for: startLine))
        extendedRange      =  NSUnionRange(extendedRange,  (string as NSString).lineRange(for: endLine))
        applyTokenAttributesToRange(extendedRange)
    }
    
    func applyTokenAttributesToRange(_ searchRange:NSRange){
        let defaultAttributes = tokens[PTLDefault.TokenName]
        let string = backingStore.string
        (string as NSString).enumerateSubstrings(in: searchRange, options: .byWords) { (substring , substringRange, enclosingRange, stop ) -> Void in
            let attributesForToken = self.tokens[substring!] ?? defaultAttributes
            
            if attributesForToken != nil{
                self.setAttributes(attributesForToken as? [String:AnyObject], range: substringRange)
            }
            
        }
        
    }
    
    
    

}
