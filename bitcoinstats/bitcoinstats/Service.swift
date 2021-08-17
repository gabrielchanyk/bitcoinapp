//
//  Service.swift
//  bitcoinstats
//
//  Created by user196869 on 7/27/21.
//

import Foundation

protocol ServiceDelegate {
    func getCountriesDidFinish(countrydata : Dictionary<String,Any>)
}

class Service  {
    
    //use delegation for countries list
    let bitcoinSession = URLSession(configuration: .default)
    var delegate : ServiceDelegate?
    
    //delagation
    func getSymbInfo(url: String){
        guard let url = URL(string: url) else {
            return
        }
        //task for getting symbol data, probably dont need to be a task because need to be done on app load just wanted to learn tasks
        //used URL instead of URL request because do not need to add anything to header
        let getSymbTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            //check for errors
            guard let data = data else{ return}
            if let myObjs = try? JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String,Any>{
                self.delegate?.getCountriesDidFinish(countrydata: myObjs)
            }
            else if error != nil
            {
                print ("HTTP Request Failed \(error!)")
            }
        }
            getSymbTask.resume()
    }
        
        //get with completion handlers
        func getValue(url: String, completion : @escaping (BitcoinValue)->Void) {
            guard let url = URL(string: url) else {return}
            //URLRequest() // apikey to the header
            var bitcoinReq = URLRequest(url:url)
            bitcoinReq.allHTTPHeaderFields = [
                "x-ba-key" : "ODQ1MDU4MzUxODQwNGU3YWI2ZWZlMjhmZjAxZGIxOWE"
            ]
            
            URLSession.shared.dataTask(with: bitcoinReq) { (data, response, error) in
                if let data = data {
                    if let bitcoinInfo = try? JSONDecoder().decode(BitcoinValue.self, from: data){
                        completion(bitcoinInfo)
                    }
                    else
                    {
                        print ("Something went wrong")
                    }
                }
                else if let error = error {
                    print ("HTTP Request Failed \(error)")
                }
            }.resume()
        }
        
        //fetch image without urlsession
        func fetchImg(url: String, completion: @escaping (Data) -> Void)
        {
            guard let url = URL(string: url) else {return}
            let imgQ = DispatchQueue(label: "imgQ")
            
            imgQ.async {
                if let imgDat = try? Data(contentsOf: url){
                    completion(imgDat)
                }
            }
        }
}
