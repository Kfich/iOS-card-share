//
//  Copyright (c) 2015 Algolia
//  http://www.algolia.com/
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

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
