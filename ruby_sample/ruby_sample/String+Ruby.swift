//
//  String+Ruby.swift
//  ruby_sample
//
//  Created by 根岸裕太 on 2018/12/08.
//  Copyright © 2018年 根岸裕太. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    func find(pattern: String) -> NSTextCheckingResult? {
        do {
            let findRubyText = try NSRegularExpression(pattern: pattern, options: [])
            return findRubyText.firstMatch(
                in: self,
                options: [],
                range: NSMakeRange(0, self.utf16.count))
        } catch {
            return nil
        }
    }
    
    func replace(pattern: String, template: String) -> String {
        do {
            let replaceRubyText = try NSRegularExpression(pattern: pattern, options: [])
            return replaceRubyText.stringByReplacingMatches(
                in: self,
                options: [],
                range: NSMakeRange(0, self.utf16.count),
                withTemplate: template)
        } catch {
            return self
        }
    }
    
    func rubyAttributedString(font: UIFont, textColor: UIColor) -> NSMutableAttributedString {
        let attributed =
            self.replace(pattern: "(｜.+?《.+?》)", template: ",$1,")
                .components(separatedBy: ",")
                .map { x -> NSAttributedString in
                    if let pair = x.find(pattern: "｜(.+?)《(.+?)》") {
                        let baseText = (x as NSString).substring(with: pair.range(at: 1))
                        let ruby = (x as NSString).substring(with: pair.range(at: 2))
                        
                        let rubyAttribute: [AnyHashable: Any] = [
                            kCTRubyAnnotationSizeFactorAttributeName: 0.5,
                            kCTForegroundColorAttributeName: textColor
                        ]
                        
                        let annotation = CTRubyAnnotationCreateWithAttributes(.auto, .auto, .before, ruby as CFString, rubyAttribute as CFDictionary)
                        
                        return NSAttributedString(
                            string: baseText,
                            attributes: [.font: font,
                                         .foregroundColor: textColor,
                                         kCTRubyAnnotationAttributeName as NSAttributedString.Key: annotation])
                        
                    } else {
                        return NSAttributedString(
                            string: x,
                            attributes: [.font: font,
                                         .foregroundColor: textColor]
                        )
                    }
                }
                .reduce(NSMutableAttributedString()) { $0.append($1); return $0 }
        
        return attributed
    }
    
    func removeRubyString() -> String {
        return self.replace(pattern: "(｜+|《.+?》)", template: "")
    }
    
}
