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
        self.amount = amount ?? NSDecimalNumber(value: 0.0 as Double)
        self.currencyCode = currencyCode ?? NumberFormatter().currencyCode
    }
    
    
    convenience init(amount:NSDecimalNumber?){
        self.init(amount:amount,currencyCode:nil)
    }
    
    convenience init(integerAmount:Int,currencyCode:String?){
        let  amount = NSDecimalNumber(value: integerAmount as Int)
        self.init(amount:amount,currencyCode:currencyCode)
    }
    
    convenience init(integerAmount:Int){
        let  amount = NSDecimalNumber(value: integerAmount as Int)
        self.init(amount:amount,currencyCode:nil)
    }
    
    convenience override init(){
        self.init(amount:0)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(amount, forKey: kRNMoney.AmountKey)
        aCoder.encode(currencyCode, forKey: kRNMoney.CurrencyCodeKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        if  let amount = aDecoder.decodeObject(forKey: kRNMoney.AmountKey) as? NSDecimalNumber,
            let currencyCode = aDecoder.decodeObject(forKey: kRNMoney.CurrencyCodeKey) as? String{
            self.init(amount:amount,currencyCode:currencyCode)
        }
        return nil
    }
    
    func localizedStringForLocale(_ alocale:Locale)->String{
        let formatter = NumberFormatter()
        formatter.locale = alocale
        formatter.currencyCode = currencyCode
        formatter.numberStyle = NumberFormatter.Style.currency
        return formatter.string(from: amount!)!
    }
    
    func localizedString()->String{
        return localizedStringForLocale(Locale.current)
    }
    
    override var  description:String { get{   return localizedString()}}

}
