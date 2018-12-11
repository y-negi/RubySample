//
//  RubyLabel.swift
//  ruby_sample
//
//  Created by 根岸裕太 on 2018/12/08.
//  Copyright © 2018年 根岸裕太. All rights reserved.
//

import UIKit

class RubyLabel: UILabel {
    
    var isUseRuby = true
    
    override func draw(_ rect: CGRect) {
        
        if !self.isUseRuby {
            // ルビを利用しない場合は文字列からルビに当たるものを取り除く
            if let unwrapText = self.text {
                self.text = unwrapText.removeRubyString()
            } else if let unwrapAttributedText = self.attributedText {
                self.attributedText =  NSAttributedString(string: unwrapAttributedText.string.removeRubyString())
            }
            
            super.draw(rect)
            
            return
        }
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        // ルビがある場合はinsetsを追加したRectにする
        let newRect: CGRect = {
            if !self.isUseRuby {
                return rect
            }
            
            // ルビがある判定
            if let unwrapText = self.text,
                unwrapText != unwrapText.removeRubyString() {
                return rect.inset(by: UIEdgeInsets(top: (self.font.pointSize * 0.75) / 2, left: 0, bottom: 0, right: 0))
            }
            if let unwrapAttributedText = self.attributedText,
                unwrapAttributedText.string != unwrapAttributedText.string.removeRubyString() {
                return rect.inset(by: UIEdgeInsets(top: (self.font.pointSize * 0.75) / 2, left: 0, bottom: 0, right: 0))
            }
            
            return rect
        }()
        
        // 文字列をルビ付きのAttributedStringにする
        let rubyAttributedString: NSMutableAttributedString = {
            if let unwrapText = self.text {
                return unwrapText.rubyAttributedString(font: self.font, textColor: self.textColor)
            }
            
            if let unwrapAttributedText = self.attributedText {
                if unwrapAttributedText.attributes(at: 0, effectiveRange: nil).map({ $0.key }).contains(kCTRubyAnnotationAttributeName as NSAttributedString.Key) {
                    return NSMutableAttributedString(attributedString: unwrapAttributedText)
                } else {
                    return unwrapAttributedText.string.rubyAttributedString(font: self.font, textColor: self.textColor)
                }
            }
            
            return NSMutableAttributedString()
        }()
        
        context.textMatrix = CGAffineTransform.identity
        context.translateBy(x: 0, y: newRect.height)
        context.scaleBy(x: 1.0, y: -1.0)
        
        let frame = CTFramesetterCreateFrame(CTFramesetterCreateWithAttributedString(rubyAttributedString),
                                             CFRangeMake(0, rubyAttributedString.length),
                                             CGPath(rect: newRect, transform: nil),
                                             nil)
        
        CTFrameDraw(frame, context)
    }
    
    override var intrinsicContentSize: CGSize {
        let displayText: String = {
            if let unwrapText = self.text {
                return unwrapText
            }
            if let unwrapAttributedText = self.attributedText {
                return unwrapAttributedText.string
            }
            
            return ""
        }()
        let baseSize = displayText.removeRubyString().size(withAttributes: [.font: self.font])
        // ルビの分の高さを追加する
        let rubySize = CGSize(width: baseSize.width, height: baseSize.height + (self.font.pointSize * 0.75) / 2)
        
        // ルビがある場合はルビの高さを追加したrectを返す
        if !self.isUseRuby {
            return baseSize
        } else {
            if let unwrapText = self.text,
                unwrapText != unwrapText.removeRubyString() {
                return rubySize
            }
            if let unwrapAttributedText = self.attributedText,
                unwrapAttributedText.string != unwrapAttributedText.string.removeRubyString() {
                return rubySize
            }
            
            return baseSize
        }
    }
    
}

