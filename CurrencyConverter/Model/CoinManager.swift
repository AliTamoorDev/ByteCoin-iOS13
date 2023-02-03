//
//  CoinManager.swift
//  ByteCoin

//  Created by Ali Tamoor on 11/04/2022

import Foundation
import UIKit
protocol CoinManagerDelegate{
    func updateCoinResults(results:Double)
    func didFailWithError(error:Error)
}
class CoinManager {
    let baseURL = "https://free.currconv.com/api/v7/convert?q="
    let currencyURL = "https://free.currconv.com/api/v7/currencies?apiKey=017d7d1ad6e91e1dc821"
    let apiKey = "017d7d1ad6e91e1dc821"
    var delegate:CoinManagerDelegate?
    var currencyArray = [String]()
    var convertedVal = 0.0
    
    // MARK: - PerformRequest for Currency Conversion
    
    func performRequest(coinModel:CoinModel){
        let url = "\(baseURL)\(coinModel.fromCurrencyLbl)_\(coinModel.toCurrencyLbl)&compact=ultra&apiKey=\(apiKey)"
        if let url = URL(string: url){
            let urlSession = URLSession(configuration: .default)
            let task = urlSession.dataTask(with: url) { data, urlResponse, error in
                if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data{
                    if let currentRate = self.parseData(data:safeData){
//                        let safeString = String(data: safeData, encoding: .utf8)
                        for (_, value) in currentRate {
                            self.convertedVal = value
                        }
                    }
                }
                DispatchQueue.main.async {
                    self.delegate?.updateCoinResults(results: self.convertedVal)
                }
            }
            task.resume()
        }
    }
    
    // MARK: - ParseData for Currency Conversion
    
    func parseData(data:Data) -> [String:Double]?{
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Double]
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    // MARK: - PerformRequest for Currency Codes
    
    func performRequestForCurrencyCode(pickerview:UIPickerView){
        
        if let url = URL(string: currencyURL){
            let urlSession = URLSession(configuration: .default)
            let task = urlSession.dataTask(with: url) { data, urlResponse, error in
                if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data{
                    //                    let safeString = String(data: safeData, encoding: .utf8)
                    //                    print(safeString)
                    if let currencyCodes = self.parseCurrencyCodeData(data:safeData){
                        self.currencyArray.append(contentsOf: currencyCodes.results.keys)
                        self.currencyArray.sort()
                        DispatchQueue.main.async {
                            pickerview.reloadAllComponents()
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    // MARK: - PerformRequest for Currency Codes
    
    func parseCurrencyCodeData(data:Data) -> CurrencyCodeData?{
        let decoder = JSONDecoder()
        do{
            let decodedData =  try decoder.decode(CurrencyCodeData.self, from: data)
//            print(decodedData)
            return decodedData
            
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
