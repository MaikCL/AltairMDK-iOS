import Foundation

@propertyWrapper
public struct Localized {
    private var key: String
    private var stringsFileName: String
    
    public init(_ key: String, stringsFileName: String = "Localizable") {
        self.key = key
        self.stringsFileName = stringsFileName
    }
    
    public var wrappedValue: String {
        NSLocalizedString(key, tableName: stringsFileName, comment: "")
    }
}
