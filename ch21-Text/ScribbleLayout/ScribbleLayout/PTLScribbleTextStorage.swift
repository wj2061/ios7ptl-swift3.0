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
    
    var tokens = [String:AnyObject]()
    
    override var string:String{
        get{
            return  backingStore.string
        }
    }
    
    override func attributesAtIndex(location: Int, effectiveRange range: NSRangePointer) -> [String : AnyObject] {
        return backingStore.attributesAtIndex(location, effectiveRange: range)
    }
    
    override func replaceCharactersInRange(range: NSRange, withString str: String) {
        beginEditing()
        backingStore.replaceCharactersInRange(range , withString: str)
        edited([.EditedAttributes,.EditedCharacters], range: range, changeInLength: (str as NSString).length-range.length)
        dynamicTextNeedsUpdate = true
        endEditing()
    }
    
    override func setAttributes(attrs: [String : AnyObject]?, range: NSRange) {
        beginEditing()
        backingStore.setAttributes(attrs, range: range)
        edited([.EditedAttributes], range: range, changeInLength: 0)
        endEditing()
    }
    
    override func processEditing() {
        if self.dynamicTextNeedsUpdate{
            self.dynamicTextNeedsUpdate = true
            performReplacementsForCharacterChangeInRange(editedRange)
        }
        super.processEditing()
    }
    
    func performReplacementsForCharacterChangeInRange(changedRange:NSRange){
        let string = backingStore.string
        let startLine = NSMakeRange(changedRange.location, 0)
        let endLine =   NSMakeRange(NSMaxRange(changedRange), 0)
        var extendedRange  = NSUnionRange(changedRange,  (string as NSString).lineRangeForRange(startLine))
        extendedRange      =  NSUnionRange(extendedRange,  (string as NSString).lineRangeForRange(endLine))
        applyTokenAttributesToRange(extendedRange)
    }
    
    func applyTokenAttributesToRange(searchRange:NSRange){
        let defaultAttributes = tokens[PTLDefault.TokenName]
        let string = backingStore.string
        (string as NSString).enumerateSubstringsInRange(searchRange, options: .ByWords) { (substring , substringRange, enclosingRange, stop ) -> Void in
            let attributesForToken = self.tokens[substring!] ?? defaultAttributes
            
            if attributesForToken != nil{
                self.setAttributes(attributesForToken as? [String:AnyObject], range: substringRange)
            }
            
        }
        
    }
    
    
    

}
