//
//  String+Conversion.swift
//  Zattini
//
//  Created by Christopher John Morris on 7/8/15.
//  Copyright (c) 2015 Concrete Solutions. All rights reserved.
//

import Foundation

extension String {
    func toDouble() -> Double? {
        return NSString(string: self).doubleValue
    }
}

extension String {
    func toComma() -> String {
        return self.stringByReplacingOccurrencesOfString(".", withString: ",")
    }
}

extension String {
    func doubleZeros() -> String {
        return self.stringByAppendingString("0")
    }
}

extension String {
    func length() -> Int {
        return Array(self.characters).count
    }
}

extension String {
    func toNSURL() -> NSURL {
        return NSURL.init(string: self)!
    }
}

extension String {
    func creditCardMask() -> String {
        return "**** **** **** \(self)"
    }
}

extension String {
    func hasOnlyCharacters(characters: String) -> Bool {
        return hasOnlyCharactersInSet(NSCharacterSet(charactersInString: characters))
    }
    
    func hasOnlyCharactersInSet(set: NSCharacterSet) -> Bool {
        return self.rangeOfCharacterFromSet(set) != nil
    }
    
    func stripDeeplinkHost() -> String {
        return self
            .stringByReplacingOccurrencesOfString("appzattini://", withString: "", options: .CaseInsensitiveSearch, range: nil)
            .stringByReplacingOccurrencesOfString("br.com.netshoes.zattini/", withString: "", options: .CaseInsensitiveSearch, range: nil)
    }
    
    func stripdeeplinkCountryCode() -> String {
        if let range = self.rangeOfString("br/", options: .CaseInsensitiveSearch, range: nil, locale: nil) {
            return self.substringFromIndex(range.endIndex)
        }
        return self
    }
}

extension String {
    func joinWithPipe() -> String {
        return self.characters.split{$0 == "|"}.map(String.init).joinWithSeparator("")
    }
}

extension String {
    func urlEncodedString() -> String {
        let urlEncodedString = self.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        return urlEncodedString ?? self
    }
}

extension String {
    func substringFromIndex(index: Int) -> String {
        if (index < 0 || index > self.characters.count) {
            return ""
        }
        return self.substringFromIndex(self.startIndex.advancedBy(index))
    }
    
    func substringToIndex(index: Int) -> String {
        if (index < 0 || index > self.characters.count) {
            return ""
        }
        return self.substringToIndex(self.startIndex.advancedBy(index))
    }
    
    func substringWithRange(start: Int, end: Int) -> String {
        if (start < 0 || start > self.characters.count) {
            return ""
        }
        else if end < 0 || end > self.characters.count {
            return ""
        }
        
        let range = Range(start: self.startIndex.advancedBy(start), end: self.startIndex.advancedBy(end))
        return self.substringWithRange(range)
    }
    
    func substringWithRange(start: Int, location: Int) -> String {
        if (start < 0 || start > self.characters.count) {
            return ""
        }
        else if location < 0 || start + location > self.characters.count {
            return ""
        }
        let range = Range(start: self.startIndex.advancedBy(start), end: self.startIndex.advancedBy(start + location))
        return self.substringWithRange(range)
    }
}
