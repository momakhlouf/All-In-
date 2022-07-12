//
//  NetworkManager.swift
//  All-In
//
//  Created by Mohamed Makhlouf Ahmed on 02/07/2022.
//

import Foundation

class NetworkManager : ApiServices{
  
    
  static let shared = NetworkManager()
  
    
    
    func fetchCategories(completion: @escaping (CustomCollections?, Error?) -> Void) {
        if let url = URL(string: "https://ios-q3-mansoura.myshopify.com/admin/api/2022-01/custom_collections.json?access_token=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"){
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data{
                    let decodJson = JSONDecoder()
                    let decodedArray = try? decodJson.decode(CustomCollections.self, from: data)
                    completion(decodedArray, nil)
                }
                if let error = error {
                    completion(nil, error)
                }
            }.resume()
        }
    }
    
    func fetchCollects(completion: @escaping (Collects?, Error?) -> Void) {
        if let url = URL(string: "https://ios-q3-mansoura.myshopify.com/admin/api/2022-01/collects.json?access_token=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"){
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data{
                    let decodJson = JSONDecoder()
                    let decodedArray = try? decodJson.decode(Collects.self, from: data)
                    completion(decodedArray, nil)
                }
                if let error = error {
                    completion(nil, error)
                }
            }.resume()
        }
    }
    
    func fetchProducts(completion: @escaping (Products?, Error?) -> Void) {
        if let url = URL(string:"https://ios-q3-mansoura.myshopify.com/admin/api/2022-01/products.json?access_token=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"){
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    let decodJson = JSONDecoder()
                    let decodedArray = try? decodJson.decode(Products.self, from: data)
                   // let decodedArray: SmartCollections = convertFromJson(data: data)!
                    completion(decodedArray,nil)
                }
                if let error = error {
                    completion(nil,error)
                }
            }.resume()
        }
    }



        
 
    func fetchBrands(completion: @escaping (SmartCollections?, Error?) -> Void) {
  //  https://ios-q3-mansoura.myshopify.com/admin/api/2022-01/smart_collections.json?7d67dd63dc90e18fce08d1f7746e9f41-Shopfiy-access_token=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
        if let url = URL(string:"https://ios-q3-mansoura.myshopify.com/admin/api/2022-01/smart_collections.json?access_token=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"){
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    let decodJson = JSONDecoder()
                    let decodedArray = try? decodJson.decode(SmartCollections.self, from: data)
                    //print(decodedArray?.smart_collections)
                   // let decodedArray: SmartCollections = convertFromJson(data: data)!
                    completion(decodedArray,nil)
                   
                }
                if let error = error {
                    completion(nil,error)
                }
            }.resume()
        }
    }


//MARK: - Mohamed - Post Address
    
    func postAddress(customerID: String, address: Address, completion: @escaping (Date?, URLResponse?, Error?) -> ()) {
        
        
        if let url = URL(string: Urls(customerId: customerID).postAddressUrl){
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpShouldHandleCookies = false
            if let httpBody = try? JSONSerialization.data(withJSONObject: address, options: []) {
                
                request.httpBody = httpBody
            }
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                
                if let data = data {
                    do{
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        
                        print(json)
                        print("post")
                    }catch {
                        print(error.localizedDescription)
                    }
                }
            }
            task.resume()
        }
        
    }
    
    
    //MARK: - Mohamed - Get Address
    func getAddress(customerId: String, completion: @escaping (([Address]?, Error?) -> Void)) {
        if let url = URL(string: Urls(customerId: customerId).addressUrl){
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data{
                    if let decodedData = try? JSONDecoder().decode(Customer.self, from: data){
                        completion(decodedData.addresses , nil)
                        print("123\(decodedData.addresses)")
                    }
                 }
            }
            task.resume()
        }
    }
    
    
    
    //MARK: - Mohamed - Delete Address
    
    func deleteAddress(customerID: String, addressID: Int, completion: @escaping (Error?) -> ()) {
        
        if let url = URL(string: Urls(customerId: customerID , addressId: addressID).deleteAddressUrl){
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    if let error = error {
                        completion(error)
                        return
                    }
                completion(nil)
                }
            }
            task.resume()
        }
        
    }
    
    //MARK: - Mohamed - Get discount Code
    func getDiscountCode( priceRule : String , completion: @escaping (([Discount_codes]?, Error?) -> Void)) {
        
        if let url = URL(string: Urls(priceRule: priceRule).discountCodeUrl){
            let task = URLSession.shared.dataTask(with: url){data, response, error in
                print(url)
                if let data = data {
                    if let decodedData = try? JSONDecoder().decode(DiscountCode.self, from: data){
                        completion(decodedData.discount_codes , nil)
                     print(decodedData.discount_codes)
                }
            }
        }
            task.resume()
        }
    }
   // 1191661535446
    
    //MARK: - Mahmoud Register
    
    
    func registerCustomer(newCustomer: NewCustomr, completion: @escaping ((NewCustomr?, Error?) -> Void))
    
    {
        print(Urls.registerUser())
        if let url = URL(string: Urls.registerUser())
        {
            print(url)
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            request.httpShouldHandleCookies = false
                
            do{
                request.httpBody =
                try JSONSerialization.data(withJSONObject: newCustomer.asDictionary(), options: .prettyPrinted)
            }
            catch let error {
                
                print(error.localizedDescription)
                
                 }
            URLSession.shared.dataTask(with: request){
                data, response, error in
                
                if let error = error {
                    completion(nil, error)
                    return
                }
                
                guard let data = data else { return }
               print(data)
                
                let decoder = JSONDecoder()
                
                if let decodedData: NewCustomr = convertFromJson(data: data)
                {
                    
                completion(decodedData, nil)
                    
                 print(decodedData)
                    
                }
            }.resume()
            
            }
        
        
    }

    
}


//
//extension Encodable {
//    func asDictionary() throws -> [String: Any] {
//        let data = try JSONEncoder().encode(self)
//        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
//            throw NSError()
//        }
//        return dictionary
//    }
//}
