//
//  Created by Miguel Angel on 25-03-21.
//

import Foundation

public protocol Exception: LocalizedError {
    var code: String { get }
    var category: ExceptionCategory { get }
    var errorDescription: String? { get }
}

public enum ExceptionCategory {
    case feature
    case network
    case storage
    case mappers
}
