

import Foundation

// MARK: - Station
struct Station: Decodable, Equatable{
    
    
    let id: Int
    let uuid, name: String
    let defaultAddress: Address
    let address, fullAddress: String
    let coordinates: Coordinates

    enum CodingKeys: String, CodingKey {
        case id, uuid, name
        case defaultAddress = "default_address"
        case address
        case fullAddress = "full_address"
        case coordinates
    }
    
    static func == (lhs: Station, rhs: Station) -> Bool {
        lhs.id == rhs.id
    }
    
}
