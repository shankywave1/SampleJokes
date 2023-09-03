//
//  JokesStyle.swift
//  SampleJokes
//
//  Created by Pran Kishore on 03/09/23.
//

import UIKit

// MARK: - Color types
public enum SJColorType: String {
    
    case darkGreen //210 243 97
    case blackText //18 18 18
    case lightBlackText //106 106 106
    
    public var color: UIColor {
        return color(for: self)
    }
    
    private func color(for description: SJColorType) -> UIColor {
        switch description {
            case .darkGreen: return UIColor(red: (210.0/255.0), green: (243.0/255.0), blue: (97.0/255.0), alpha: 1.0)
            case .blackText: return UIColor(red: 18.0/255.0, green: 18.0/255.0, blue: 18.0/255.0, alpha: 1.0)
            case .lightBlackText: return UIColor(red: 106.0/255.0, green: 106.0/255.0, blue: 106.0/255.0, alpha: 1.0)
        }
    }
}

// MARK: - Font Size
public enum SJSizeType: CGFloat, RawRepresentable, CustomStringConvertible {
    
    public typealias RawValue = CGFloat
    
    case tiny
    case small
    case compact
    case medium
    case big
    
    public var rawValue: RawValue {
        switch self {
            case .tiny: return 10.0
            case .small: return 12.0
            case .compact: return 14.0
            case .medium: return 16.0
            case .big: return 20.0
        }
    }
    
    public init?(rawValue: RawValue) {
        
        switch rawValue {
            case 10.0: self = .tiny
            case 12.0: self = .small
            case 14.0: self = .compact
            case 16.0: self = .medium
            case 20.0: self = .big
            default:
                self = .tiny
        }
    }
    
    public var description: String {
        return "SJSizeType Size :\(fontSize)"
    }
    
    public var fontSize: CGFloat {
        return rawValue
    }
}

// MARK: - Font Type
public enum SJFontType: String, CustomStringConvertible {
    
    case light
    case bold
    case regular
    
    public var description: String {
        return "StyleDescription : Font name : \(fontName)"
    }
    
    public var fontName: String {
        return rawValue
    }
    
    public var fontWeight: UIFont.Weight {
        switch self {
            case .light: return UIFont.Weight.light
            case .regular: return UIFont.Weight.regular
            case .bold: return UIFont.Weight.bold
        }
    }
    
    public func font(with pointSize: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: pointSize)
    }
    
    public func font(with pointSize: SJSizeType) -> UIFont {
        return font(with: pointSize.fontSize)
    }
}

// MARK: - Style
open class SJStyle: CustomStringConvertible {
    
    fileprivate let fontType: SJFontType
    fileprivate let sizeType: SJSizeType
    fileprivate let colorType: SJColorType
    
    public init (fontType: SJFontType, sizeType: SJSizeType, colorType: SJColorType) {
        self.fontType = fontType
        self.sizeType = sizeType
        self.colorType = colorType
    }
    
    var font: UIFont {
        return UIFont.systemFont(ofSize: sizeType.fontSize, weight: fontType.fontWeight)
    }
    
    open var description: String {
        return "SJStyle: \(fontType) : \(sizeType) : \(colorType)"
    }
    
    public static var elementTitle: SJStyle {
        return SJStyle(fontType: .regular, sizeType: .medium, colorType: .blackText)
    }
    public static var elementDetail: SJStyle {
        return SJStyle(fontType: .regular, sizeType: .compact, colorType: .lightBlackText)
    }
}

public extension UILabel {
    func apply(style: SJStyle) {
        font = style.font
        textColor = style.colorType.color
    }
    
}
