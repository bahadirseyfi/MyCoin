//
//  CoinManager.swift
//  MyCoin
//
//  Created by bahadir on 27.10.2020.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdatePrice(price: String, currency: String)
    func didFailWithError(error: Error) 

}

struct CoinManager {
    
    var delegate : CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/"
    let baseArray = ["BTC","ETH"]
    let apiKey = "304C3B72-CF23-4E70-A6B6-1D71887B0EF4"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    
    func getCoinPrice(for currency: String, base: String) {
        let urlString = "\(baseURL)\(base)/\(currency)?apikey=\(apiKey)"
        
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data {
//                    let bitcoinPrice = self.parseJSON(safeData)
                    if let bitcoinPrice = self.parseJSON(safeData){
                        let priceString = String(format: "%.2f", bitcoinPrice)
                        self.delegate?.didUpdatePrice(price: priceString, currency: currency)
                    }
                }
//                let dataAsString = String(data: data!, encoding: .utf8)
//                print(dataAsString!)
            }
            
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> Double? {
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(CoinData.self, from: data)
            
            let lastPrice = decodedData.rate
            print(lastPrice)
            return lastPrice
        } catch {
            print(error)
            return nil
        }
    }
    
}
