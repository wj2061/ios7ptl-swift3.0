//
//  RNMoney.swift
//  Money
//
//  Created by WJ on 15/11/11.
//  Copyright © 2015年 wj. All rights reserved.
//

import Cocoa
import Foundation
private struct kRNMoney{
    static let AmountKey = "key"
    static let CurrencyCodeKey = "currencyCode"
}

class RNMoney: NSObject,NSCoding {

    var amount:NSDecimalNumber?
    var currencyCode:String?
    
    init(amount:NSDecimalNumber?,currencyCode:String?){
        super.init()
        self.amount = amount ?? NSDecimalNumber(double: 0.0)
        self.currencyCode = currencyCode ?? NSNumberFormatter().currencyCode
    }
    
    
    convenience init(amount:NSDecimalNumber?){
        self.init(amount:amount,currencyCode:nil)
    }
    
    convenience init(integerAmount:Int,currencyCode:String?){
        let  amount = NSDecimalNumber(integer: integerAmount)
        self.init(amount:amount,currencyCode:currencyCode)
    }
    
    convenience init(integerAmount:Int){
        let  amount = NSDecimalNumber(integer: integerAmount)
        self.init(amount:amount,currencyCode:nil)
    }
    
    convenience override init(){
        self.init(amount:0)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(amount, forKey: kRNMoney.AmountKey)
        aCoder.encodeObject(currencyCode, forKey: kRNMoney.CurrencyCodeKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        if  let amount = aDecoder.decodeObjectForKey(kRNMoney.AmountKey) as? NSDecimalNumber,
            let currencyCode = aDecoder.decodeObjectForKey(kRNMoney.CurrencyCodeKey) as? String{
            self.init(amount:amount,currencyCode:currencyCode)
        }
        return nil
    }
    
    func localizedStringForLocale(alocale:NSLocale)->String{
        let formatter = NSNumberFormatter()
        formatter.locale = alocale
        formatter.currencyCode = currencyCode
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        return formatter.stringFromNumber(amount!)!
    }
    
    func localizedString()->String{
        return localizedStringForLocale(NSLocale.currentLocale())
    }
    
    override var  description:String { get{   return localizedString()}}

}
