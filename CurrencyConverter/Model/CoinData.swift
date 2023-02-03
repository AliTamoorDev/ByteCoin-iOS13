//
//  CoinData.swift
//  ByteCoin
//
//  Created by Ali Tamoor  on 11/04/2022.

import Foundation
struct CoinData:Decodable{
   let rate:Double
}
struct CurrencyCodeData:Decodable{
    let results:[String:CurrencyName]
}
struct CurrencyName:Decodable{
    let currencyName:String
}
