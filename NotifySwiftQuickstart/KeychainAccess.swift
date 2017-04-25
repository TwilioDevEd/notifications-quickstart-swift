/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 A struct for accessing generic password keychain items.
 */

import Foundation

struct KeychainAccess {
    // MARK: Types
    
    enum KeychainError: Error {
        case noEndpoint
        case unexpectedEndpointData
        case unhandledError(status: OSStatus)
    }
    
    // MARK: Properties
    
    static var service: String = "Twilio-Notify"
    
    
/*

    init(service: String?, account: String?, accessGroup: String? = nil) {
        self.service = service!
        self.account = account!
        self.accessGroup = accessGroup
    }
*/
    // MARK: Keychain access
    
    static func readEndpoint(identity: String) throws -> String  {
        /*
         Build a query to find the item that matches the service, account and
         access group.
         */
        var query = KeychainAccess.keychainQuery(withService: service, account: identity)
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        query[kSecReturnData as String] = kCFBooleanTrue
        
        // Try to fetch the existing keychain item that matches the query.
        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }
        
        // Check the return status and throw an error if appropriate.
        guard status != errSecItemNotFound else { throw KeychainError.noEndpoint }
        guard status == noErr else { throw KeychainError.unhandledError(status: status) }
        
        // Parse the endpoint string from the query result.
        guard let existingItem = queryResult as? [String : AnyObject],
            let endpointData = existingItem[kSecValueData as String] as? Data,
            let endpoint = String(data: endpointData, encoding: String.Encoding.utf8)
            else {
                throw KeychainError.unexpectedEndpointData
        }
        
        return endpoint
    }
    
    static func saveEndpoint(identity: String, endpoint: String) throws {
        // Encode the endpoint into an Data object.
        let encodedEndpoint = endpoint.data(using: String.Encoding.utf8)!
        
        do {
            // Check for an existing item in the keychain.
            try _ = readEndpoint(identity: identity)
            
            // Update the existing item with the new endpoint.
            var attributesToUpdate = [String : AnyObject]()
            attributesToUpdate[kSecValueData as String] = encodedEndpoint as AnyObject?
            
            let query = KeychainAccess.keychainQuery(withService: service, account: identity)
            let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
            
            // Throw an error if an unexpected status was returned.
            guard status == noErr else { throw KeychainError.unhandledError(status: status) }
        }
        catch KeychainError.noEndpoint {
            /*
             No endpoint was found in the keychain. Create a dictionary to save
             as a new keychain item.
             */
            var newItem = KeychainAccess.keychainQuery(withService: service, account: identity)
            newItem[kSecValueData as String] = encodedEndpoint as AnyObject?
            
            // Add a the new item to the keychain.
            let status = SecItemAdd(newItem as CFDictionary, nil)
            
            // Throw an error if an unexpected status was returned.
            guard status == noErr else { throw KeychainError.unhandledError(status: status) }
        }
    }

    
    static func deleteItem(identity: String) throws {
        // Delete the existing item from the keychain.
        let query = KeychainAccess.keychainQuery(withService: service, account: identity)
        let status = SecItemDelete(query as CFDictionary)
        
        // Throw an error if an unexpected status was returned.
        guard status == noErr || status == errSecItemNotFound else { throw KeychainError.unhandledError(status: status) }
    }
    
    // MARK: Convenience
    
private static func keychainQuery(withService service: String, account: String? = nil, accessGroup: String? = nil) -> [String : AnyObject] {
        var query = [String : AnyObject]()
        query[kSecClass as String] = kSecClassGenericPassword
        query[kSecAttrService as String] = service as AnyObject?
        
        if let account = account {
            query[kSecAttrAccount as String] = account as AnyObject?
        }
        
        if let accessGroup = accessGroup {
            query[kSecAttrAccessGroup as String] = accessGroup as AnyObject?
        }
        
        return query
    }
}
