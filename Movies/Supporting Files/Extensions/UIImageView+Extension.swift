//
//  UIImageView+Extension.swift
//  MediaDownloader
//
//  Created by Abraham Isaac Durán on 10/25/18.
//  Copyright © 2018 Abraham Isaac Durán. All rights reserved.
//

import Foundation
import AlamofireImage

extension UIImageView {
    func setImage(with url: URL, placeholder: UIImage? = UIImage(), completion: ((Data?) -> Void)? = nil) {
        af_setImage(withURL: url, placeholderImage: placeholder, imageTransition: .crossDissolve(0.5)) { response in
            if let value = response.value {
                completion?(value.pngData())
            } else {
                self.image = UIImage(named: "no-poster")
            }
        }
    }
}
