//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate{
    func updateCurrencyPriceLabels(currency:String,rate:Double?)
    func errorWhenApiFails(error:Error)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "9D6B03A0-A1B3-4EB0-BDF1-87E337ECFBED"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    var delegate : CoinManagerDelegate?
    
    func getCoinPrice(for currency:String){
        let url = baseURL + "/\(currency)?apikey=\(apiKey)"
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: URL(string: url)!,
                                    completionHandler: {(data:Data?,response:URLResponse?,error:Error?) in
                                        if error != nil{
                                            print(error!)
                                            return
                                            }
                                        if let safeData = data{
                                            if let rate = parseJson(data: safeData) {
                                                self.delegate?.updateCurrencyPriceLabels(currency:currency,
                                                                               rate:rate)
                                                
                                            }
                                        }
                                    }
                                    )
        task.resume()
    }
    
    func parseJson(data: Data) -> Double?{
        let decoder = JSONDecoder()
        do{
        let decodedData = try decoder.decode(CoinData.self, from: data)
            return decodedData.rate
        }catch{
            self.delegate?.errorWhenApiFails(error: error)
        }
        return nil
    }
}
