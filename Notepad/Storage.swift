//
//  Storage.swift
//  Notepad
//
//  Created by Rudd Fawcett on 10/14/16.
//  Copyright © 2016 Rudd Fawcett. All rights reserved.
//

#if os(iOS)
    import UIKit
#elseif os(macOS)
    import AppKit
#endif

public class Storage: NSTextStorage {
    /// The Theme for the Notepad.
    public var theme: Theme? {
        didSet {
            let wholeRange = NSRange(location: 0, length: (string as NSString).length)

            beginEditing()
            applyStyles(wholeRange)
            edited(.editedAttributes, range: wholeRange, changeInLength: 0)
            endEditing()
        }
    }

    /// The underlying text storage implementation.
    var backingStore = NSTextStorage()

    override public var string: String {
        return backingStore.string
    }

    override public init() {
        super.init()
    }

    override public init(attributedString attrStr: NSAttributedString) {
        super.init(attributedString: attrStr)
        backingStore.setAttributedString(attrStr)
    }

    @available(*, unavailable)
    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public required init(itemProviderData _: Data, typeIdentifier _: String) throws {
        fatalError("init(itemProviderData:typeIdentifier:) has not been implemented")
    }

    #if os(macOS)
        public required init?(pasteboardPropertyList _: Any, ofType _: String) {
            fatalError("init(pasteboardPropertyList:ofType:) has not been implemented")
        }

        public required init?(pasteboardPropertyList _: Any, ofType _: NSPasteboard.PasteboardType) {
            fatalError("init(pasteboardPropertyList:ofType:) has not been implemented")
        }
    #endif

    /// Finds attributes within a given range on a String.
    ///
    /// - parameter location: How far into the String to look.
    /// - parameter range:    The range to find attributes for.
    ///
    /// - returns: The attributes on a String within a certain range.
    override public func attributes(at location: Int, longestEffectiveRange range: NSRangePointer?, in rangeLimit: NSRange) -> [NSAttributedString.Key: Any] {
        return backingStore.attributes(at: location, longestEffectiveRange: range, in: rangeLimit)
    }

    /// Replaces edited characters within a certain range with a new string.
    ///
    /// - parameter range: The range to replace.
    /// - parameter str:   The new string to replace the range with.
    override public func replaceCharacters(in range: NSRange, with str: String) {
        beginEditing()
        backingStore.replaceCharacters(in: range, with: str)
        let len = (str as NSString).length
        let change = len - range.length
        edited([.editedCharacters, .editedAttributes], range: range, changeInLength: change)
        endEditing()
    }

    /// Sets the attributes on a string for a particular range.
    ///
    /// - parameter attrs: The attributes to add to the string for the range.
    /// - parameter range: The range in which to add attributes.
    override public func setAttributes(_ attrs: [NSAttributedString.Key: Any]?, range: NSRange) {
        beginEditing()
        backingStore.setAttributes(attrs, range: range)
        edited(.editedAttributes, range: range, changeInLength: 0)
        endEditing()
    }

    /// Retrieves the attributes of a string for a particular range.
    ///
    /// - parameter at: The location to begin with.
    /// - parameter range: The range in which to retrieve attributes.
    override public func attributes(at location: Int, effectiveRange range: NSRangePointer?) -> [NSAttributedString.Key: Any] {
        return backingStore.attributes(at: location, effectiveRange: range)
    }

    /// Processes any edits made to the text in the editor.
    override public func processEditing() {
        let backingString = backingStore.string
        if let nsRange = backingString.range(from: NSMakeRange(NSMaxRange(editedRange), 0)) {
            let indexRange = backingString.lineRange(for: nsRange)
            let extendedRange: NSRange = NSUnionRange(editedRange, backingString.nsRange(from: indexRange))
            applyStyles(extendedRange)
        }
        super.processEditing()
    }

    /// Applies styles to a range on the backingString.
    ///
    /// - parameter range: The range in which to apply styles.
    func applyStyles(_ range: NSRange) {
        guard let theme = theme else { return }

        let backingString = backingStore.string
        backingStore.setAttributes(theme.body.attributes, range: range)

        for style in theme.styles {
            style.regex.enumerateMatches(in: backingString, options: .withoutAnchoringBounds, range: range, using: { match, _, _ in
                guard let match = match else { return }
                backingStore.addAttributes(style.attributes, range: match.range(at: 0))
            })
        }
    }
}
