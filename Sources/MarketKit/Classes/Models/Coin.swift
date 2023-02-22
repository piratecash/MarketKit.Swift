import GRDB
import ObjectMapper

public class Coin: Record, Decodable, ImmutableMappable {
    static let tokens = hasMany(TokenRecord.self)

    public let uid: String
    public let name: String
    public let code: String
    public let marketCapRank: Int?
    public let coinGeckoId: String?
    public let priority: Int?

    override open class var databaseTableName: String {
        "coin"
    }

    enum Columns: String, ColumnExpression {
        case uid, name, code, marketCapRank, coinGeckoId, priority
    }

    public init(uid: String, name: String, code: String, marketCapRank: Int? = nil, coinGeckoId: String? = nil, priority: Int? = 100) {
        self.uid = uid
        self.name = name
        self.code = code
        self.marketCapRank = marketCapRank
        self.coinGeckoId = coinGeckoId
        self.priority = priority

        super.init()
    }

    required public init(map: Map) throws {
        uid = try map.value("uid")
        name = try map.value("name")
        let code: String = try map.value("code")
        self.code = code.uppercased()
        marketCapRank = try? map.value("market_cap_rank")
        coinGeckoId = try? map.value("coingecko_id")
        priority = try? map.value("priority")

        super.init()
    }

    public func mapping(map: Map) {
        uid >>> map["uid"]
        name >>> map["name"]
        code >>> map["code"]
        marketCapRank >>> map["market_cap_rank"]
        coinGeckoId >>> map["coingecko_id"]
        priority >>> map["priority"]
    }

    required init(row: Row) {
        uid = row[Columns.uid]
        name = row[Columns.name]
        code = row[Columns.code]
        marketCapRank = row[Columns.marketCapRank]
        coinGeckoId = row[Columns.coinGeckoId]
        priority = row[Columns.priority]

        super.init(row: row)
    }

    override open func encode(to container: inout PersistenceContainer) {
        container[Columns.uid] = uid
        container[Columns.name] = name
        container[Columns.code] = code
        container[Columns.marketCapRank] = marketCapRank
        container[Columns.coinGeckoId] = coinGeckoId
        container[Columns.priority] = priority
    }

}

extension Coin: Hashable {

    public func hash(into hasher: inout Hasher) {
        hasher.combine(uid)
    }

}

extension Coin: Equatable {

    public static func ==(lhs: Coin, rhs: Coin) -> Bool {
        lhs.uid == rhs.uid
    }

}

extension Coin: CustomStringConvertible {

    public var description: String {
        "Coin [uid: \(uid); name: \(name); code: \(code); marketCapRank: \(marketCapRank.map { "\($0)" } ?? "nil"); coinGeckoId: \(coinGeckoId.map { "\($0)" } ?? "nil"); priority: \(priority.map { "\($0)" } ?? "nil")]"
    }

}
