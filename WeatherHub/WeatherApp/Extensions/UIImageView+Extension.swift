//
//  UIImageView+Extension.swift
//  WeatherApp
//
//  Created by Ahmed Mohamed on 05/24/2023.
//  Copyright © 2023 Ahmed Mohamed. All rights reserved.


import Foundation
import UIKit

extension UIImageView {
    func downloadImage(from url: URL) {
           URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
               guard let self = self,
                     let data = data,
                     error == nil,
                     let image = UIImage(data: data)
               else {
                   return
               }
               
               DispatchQueue.main.async {
                   self.image = image
               }
           }.resume()
       }
}
