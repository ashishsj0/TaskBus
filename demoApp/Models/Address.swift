
import Foundation

// MARK: - DefaultAddress
struct Address: Decodable {
    let address, fullAddress: String?
    let coordinates: Coordinates?

    enum CodingKeys: String, CodingKey {
        case address
        case fullAddress = "full_address"
        case coordinates
    }
}
