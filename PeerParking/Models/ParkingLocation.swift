import Foundation

// MARK: - ParkingLocation
class ParkingLocation: Codable {
    var lastDate: LastDate?
    var latitude, longitude: Double?

    enum CodingKeys: String, CodingKey {
        case lastDate = "LastDate"
        case latitude = "Latitude"
        case longitude = "Longitude"
        
        
    }

    init() {
        
    }
    init(lastDate: LastDate?, latitude: Double?, longitude: Double?) {
        self.lastDate = lastDate
        self.latitude = latitude
        self.longitude = longitude
    }
}

// MARK: - LastDate
class LastDate: Codable {
    var date, day, hours, minutes: Int?
    var month, seconds, time, timezoneOffset: Int?
    var year: Int?

  
}
