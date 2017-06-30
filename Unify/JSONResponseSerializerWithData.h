
#import "AFURLResponseSerialization.h"

/// NSError userInfo keys that will contain response data
static NSString * const kJSONBodyKey = @"kJSONBodyKey";
static NSString * const kJSONStatusCodeKey = @"kJSONStatusCodeKey";

@interface JSONResponseSerializerWithData : AFJSONResponseSerializer

@end
