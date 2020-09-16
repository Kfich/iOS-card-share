import AlgoliaSearch
import InstantSearchCore
import Foundation


struct ContactRecord {
    private let json: JSONObject
    
    init(json: JSONObject) {
        self.json = json
    }

    var givenName: String? {
        return json["givenName"] as? String
    }
    
    var imageUrl: URL? {
        guard let urlString = json["image"] as? String else {
            return nil
        }
        return URL(string: urlString)
    }
    
    var title_highlighted: String? {
        return SearchResults.highlightResult(hit: json, path: "title")?.value
    }

    var rating: Int? {
        return json["rating"] as? Int
    }
    
    var year: Int? {
        return json["year"] as? Int
    }
}
