//
//  LocalizedPhone.swift
//
//  Copyright 2015 Emily Ivie

//  Licensed under The MIT License
//  For full copyright and license information, please see http://opensource.org/licenses/MIT
//  Redistributions of files must retain the above copyright notice.

import Foundation

/**
    Example:::
    
    @IBAction func formValueChanged(sender: UITextField) {
        sender.text = LocalizedPhone.format(sender.text, hash: sender.hash)
    }
*/
public struct LocalizedPhone {

    /**
        Set available locales here.
    */
    private enum AvailableLocales: String {
        case UnitedStates = "US",
             Canada = "CA"
    }
    
    /**
        Set default locale here.
    */
    private static var defaultLocale = AvailableLocales.UnitedStates
    
    /**
        Set formats for available locales here.
        (expect a string of correct length, but match with dot (.), not digit (\d))
    */
    private static let formatByLocale: [AvailableLocales: Format] = [
        .UnitedStates: Format(length: 10, match: "^(...)(...)(....)$", format: "($1) $2-$3"),
        .Canada: Format(length: 10, match: "^(...)(...)(....)$", format: "($1) $2-$3"),
    ]
    
    /**
        Supporting definitions here.
    */
    private struct Format {
        var length: Int, match: String, format: String
    }
    private static var locale: AvailableLocales = {
        if let country = NSLocale.currentLocale().objectForKey(NSLocaleCountryCode) as? String,
           let locale = AvailableLocales(rawValue: country) {
            return locale
        }
        return LocalizedPhone.defaultLocale
    }()
    private static var lastPhoneNumbers: [Int: String] = [:]
    
    //Mark: Public functions:
    
    /**
        Turns a phone number into a pretty formatted phone number for the current locale. Strips text down to numbers before running.
        
        :param: phoneNumber      Any string with numbers or existing formatting
        :param: hash             If you are dealing with multiple phone numbers, you will need to include a unique id for each (field.hash is good)
        :returns:                Formatted phone number string
    */
    public static func format(phoneNumber: String, hash: Int = 0) -> String {
        //strip to numbers
        var numericText = phoneNumber.onlyCharacters("0123456789")
        if numericText.length == 0 {
            self.lastPhoneNumbers[hash] = ""
            return ""
        }
        if let formatStyle = self.formatByLocale[self.locale] {
            //if characters removed by user, change to remove numbers instead of formatting
            let lastPhoneNumber = self.lastPhoneNumbers[hash] ?? ""
            let lastNumericText = lastPhoneNumber.onlyCharacters("0123456789")
            let requestedSubtractChars = lastPhoneNumber.length - phoneNumber.length
            let actualSubtractChars = max(0, lastNumericText.length - numericText.length)
            if requestedSubtractChars > 0 && actualSubtractChars < requestedSubtractChars {
                let subtractChars = requestedSubtractChars - actualSubtractChars
                println(subtractChars)
                numericText = subtractChars >= numericText.length  ? "" : numericText.stringFrom(0, to: -1 * subtractChars)
            }
            //add formatting
            let placeholder = "*"
            if numericText.length < formatStyle.length {
                numericText = numericText.rpad(placeholder, length: formatStyle.length)
            }
            if numericText.length > formatStyle.length {
                numericText = numericText.stringFrom(0, to: formatStyle.length)
            }
            let fullyFormattedNumber = numericText.stringByReplacingOccurrencesOfString(formatStyle.match, withString: formatStyle.format, options: NSStringCompareOptions.RegularExpressionSearch, range: nil)
            if let editingNumber = split(fullyFormattedNumber, maxSplit: 1, allowEmptySlices: true, isSeparator: {Character(placeholder) == $0}).first {
                self.lastPhoneNumbers[hash] = editingNumber
                return editingNumber
            }
            self.lastPhoneNumbers[hash] = fullyFormattedNumber
            return fullyFormattedNumber
        }
        return numericText
    }
    
    /**
        Checks phone number is a valid phone number for the current locale.
        
        :param: phoneNumber      A numeric phone number. Expects no formatting!
        :returns:                True if phone number matches locale pattern
    */
    public static func isValid(phoneNumber: String) -> Bool {
        var numericText = phoneNumber.onlyCharacters("0123456789")
        if let formatStyle = self.formatByLocale[self.locale] {
            return numericText.length == formatStyle.length
        }
        return false
    }
}
