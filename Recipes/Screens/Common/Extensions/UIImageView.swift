//
//  UIImageView.swift
//  Recipes
//
//  Created by Damian Markowski on 24.02.2018.
//  Copyright © 2018 Damian Markowski. All rights reserved.
//

import UIKit

let imageCache = NSCache<NSString, AnyObject>()

extension UIImageView {
    
    func loadImageUsingCache(withUrl urlString: String, completionHandler:@escaping ((_ success: Bool)->())) {
        guard let url = URL(string: urlString) else { return }
        self.image = nil
        if let cachedImage = imageCache.object(forKey: urlString as NSString) as? UIImage {
            self.image = cachedImage
            completionHandler(true)
            return
        }

        URLSession.shared.dataTask(with: url, completionHandler: {[weak self] (data, response, error) in
            if error != nil {
                print(error!)
                completionHandler(false)
                return
            }
            if let data = data {
                DispatchQueue.main.async {
                    if let image = UIImage(data: data) {
                        imageCache.setObject(image, forKey: urlString as NSString)
                        self?.image = image
                        completionHandler(true)
                    }else{
                        completionHandler(false)
                    }
                }
            }
        }).resume()
    }
}
