

import Foundation

extension String {
    var localized: String{
        return NSLocalizedString(self, comment: "")
    }
    
    func lacalized(WithComment comment : String) -> String {
        return NSLocalizedString(self, comment: comment)
    }
}


