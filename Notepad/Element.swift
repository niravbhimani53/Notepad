//
//  Element.swift
//  Notepad
//
//  Created by Rudd Fawcett on 10/14/16.
//  Copyright © 2016 Rudd Fawcett. All rights reserved.
//

import Foundation

/// A String type enum to keep track of the different elements we're tracking with regex.
public enum Element: String {
    case unknown = "x^"

    case h1 = "^(\\#{1}(.*))$"
    case h2 = "^(\\#{2}(.*))$"
    case h3 = "^(\\#{3}(.*))$"
    case h4 = "^(\\#{4}(.*))$"
    case h5 = "^(\\#{5}(.*))$"
    case h6 = "^(\\#{6}(.*))$"

    case body = ".*"

    case bold = "(^|[\\W_])(?:(?!\\1)|(?=^))(\\*|_)\\2(?=\\S)(.*?\\S)\\2\\2(?!\\2)(?=[\\W_]|$)"
    case italic = "(^|[\\W_])(?:(?!\\1)|(?=^))(\\*|_)(?=\\S)((?:(?!\\2).)*?\\S)\\2(?!\\2)(?=[\\W_]|$)"
    case boldItalic = "(\\*\\*\\*\\w+(\\s\\w+)*\\*\\*\\*)"
    
    case code = "(^|[\\W_])(?:(?!\\1)|(?=^))`{1}[^`]+`{1}"

    case blockQuote = "^>.*"
    case horizontalRule = "(\n)(-{3})(\n)"

    case unorderedList = "^(\\-|\\*)\\s"
    case orderedList = "^\\d*\\.\\s"

    case footNote = "\\[\\^(.*?)\\]"

    case strikeThrough = "(~)((?!\\2).)+\\2"
    case html = "<(\"[^\"]*\"|'[^']*'|[^'\">])*>"

    case url = "!?\\[([^\\[\\]]*)\\]\\((.*?)\\)"
    case image = "\\!\\[([^\\]]+)\\]\\(([^\\)\"\\s]+)(?:\\s+\"(.*)\")?\\)"

    /// Converts an enum value (type String) to a NSRegularExpression.
    ///
    /// - returns: The NSRegularExpression.
    func toRegex() -> NSRegularExpression {
        return rawValue.toRegex()
    }

    /// Returns an Element enum based upon a String.
    ///
    /// - parameter string: The String representation of the enum.
    ///
    /// - returns: The Element enum match.
    func from(string: String) -> Element {
        switch string {
        case "h1": return .h1
        case "h2": return .h2
        case "h3": return .h3
        case "h4": return .h4
        case "h5": return .h5
        case "h6": return .h6
        case "body": return .body
        case "bold": return .bold
        case "italic": return .italic
        case "boldItalic": return .boldItalic
        case "code": return .code
        case "url": return .url
        case "image": return .image
        case "blockQuote": return .blockQuote
        case "horizontalRule": return .horizontalRule
        case "unorderedList": return .unorderedList
        case "orderedList": return .orderedList
        case "strikeThrough": return .strikeThrough
        case "html": return .html
        case "footNote": return .footNote
        default: return .unknown
        }
    }
}
