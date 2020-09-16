import AFNetworking
import AlgoliaSearch
import Foundation


private let DEFAULTS_KEY_MIRRORED       = "algolia.mirrored"
private let DEFAULTS_KEY_STRATEGY       = "algolia.requestStrategy"
private let DEFAULTS_KEY_TIMEOUT        = "algolia.offlineFallbackTimeout"


class AlgoliaManager: NSObject {
    /// The singleton instance.
    static let sharedInstance = AlgoliaManager()

    let client: Client
    var contactsIndex: Index
    
    private override init() {
        let apiKey = "b22a25b4ddb022785de173c897bd290b"
        client = Client(appID: "DY28EK58WZ", apiKey: apiKey)
        contactsIndex = client.index(withName: "contacts")
    }
}
