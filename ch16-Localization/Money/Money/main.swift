//
//  main.swift
//  Money
//
//  Created by WJ on 15/11/11.
//  Copyright © 2015年 wj. All rights reserved.
//

import Foundation

print("Hello, World!")

let russianLocale = NSLocale(localeIdentifier: "ru_RU")

let money = RNMoney(amount: 100)

print("Local display of local currency: \(money)")
print("Russian display of local currency : \(money.localizedStringForLocale(russianLocale))")

let euro = RNMoney(amount: 200, currencyCode: "EUR")
print("Local display of Euro: \(euro)")
print("Russian display of Euro: \(euro.localizedStringForLocale(russianLocale)) ")



