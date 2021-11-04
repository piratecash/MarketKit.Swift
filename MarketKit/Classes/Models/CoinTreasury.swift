import Foundation
import ObjectMapper

public class CoinTreasury: ImmutableMappable {
    public let type: TreasuryType
    public let fund: String
    public let amount: Decimal
    public let amountInCurrency: Decimal
    public let country: String

    required public init(map: Map) throws {
        type = try map.value("type")
        fund = try map.value("fund")
        amount = try map.value("amount", using: Transform.stringToDecimalTransform)
        amountInCurrency = try map.value("amountInCurrency", using: Transform.stringToDecimalTransform)
        country = try map.value("country")
    }

    public enum TreasuryType: String {
        case `public`
        case `private`
        case etf
    }

}