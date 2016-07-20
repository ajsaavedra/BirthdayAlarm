//
//  ImageStore.swift
//  BirthdayAlarm
//
//  Created by Tony Saavedra on 7/19/16.
//  Copyright © 2016 Tony Saavedra. All rights reserved.
//

import UIKit

class ImageStore {
    let cache = NSCache()
    
    func setImage(image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key)
    }
    
    func imageForKey(key: String) -> UIImage? {
        return cache.objectForKey(key) as? UIImage
    }
    
    func deleteImageForKey(key: String) {
        cache.removeObjectForKey(key)
    }
}
