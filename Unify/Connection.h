#import <Foundation/Foundation.h>

typedef void(^CompletionBlock)(id dictionary, NSError *error);

@interface Connection : NSObject

- (id)initWithConfiguration:(NSURLSessionConfiguration*)sessionConfiguration;
+ (NSNumber *)errorStatusCode:(NSError *)error;
+ (NSDictionary *)errorBody:(NSError *)error;

// Users
- (NSURLSessionDataTask*)createUserCall:(NSDictionary*)parameters completionBlock:(CompletionBlock)completionBlock;
- (NSURLSessionDataTask*)getUserCall:(NSDictionary*)parameters completionBlock:(CompletionBlock)completionBlock;
- (NSURLSessionDataTask*)updateUserCall:(NSDictionary*)parameters completionBlock:(CompletionBlock)completionBlock;
- (NSURLSessionDataTask*)getUserListCall:(NSDictionary*)parameters completionBlock:(CompletionBlock)completionBlock;

// Cards
- (NSURLSessionDataTask*)createCardCall:(NSDictionary*)parameters completionBlock:(CompletionBlock)completionBlock;
- (NSURLSessionDataTask*)getCardsCall:(NSDictionary*)parameters completionBlock:(CompletionBlock)completionBlock;
- (NSURLSessionDataTask*)updateCardCall:(NSDictionary*)parameters completionBlock:(CompletionBlock)completionBlock;
- (NSURLSessionDataTask*)deleteCardCall:(NSDictionary*)parameters completionBlock:(CompletionBlock)completionBlock;


- (NSURLSessionDataTask*)getSingleCardCall:(NSDictionary*)parameters completionBlock:(CompletionBlock)completionBlock;

// Transactions
- (NSURLSessionDataTask*)createTransactionCall:(NSDictionary*)parameters completionBlock:(CompletionBlock)completionBlock;
- (NSURLSessionDataTask*)getTransactionsCall:(NSDictionary*)parameters completionBlock:(CompletionBlock)completionBlock;
- (NSURLSessionDataTask*)updateTransactionCall:(NSDictionary*)parameters transactionID:(NSString*)transactionID completionBlock:(CompletionBlock)completionBlock;
- (NSURLSessionDataTask*)approveTransactionCall:(NSDictionary*)parameters completionBlock:(CompletionBlock)completionBlock;
- (NSURLSessionDataTask*)rejectTransactionCall:(NSDictionary*)parameters completionBlock:(CompletionBlock)completionBlock;


// Auth
- (NSURLSessionDataTask*)logoutCall:(NSDictionary*)parameters userID:(NSString*)userID completionBlock:(CompletionBlock)completionBlock;
- (NSURLSessionDataTask*)refreshTokenCall:(NSDictionary*)parameters userID:(NSString*)userID completionBlock:(CompletionBlock)completionBlock;

- (NSURLSessionDataTask*)issuePinCall:(NSDictionary*)parameters completionBlock:(CompletionBlock)completionBlock;
- (NSURLSessionDataTask*)verifyPinCall:(NSDictionary*)parameters completionBlock:(CompletionBlock)completionBlock;


// Geo
- (NSURLSessionDataTask*)startRadarCall:(NSDictionary*)parameters completionBlock:(CompletionBlock)completionBlock;
- (NSURLSessionDataTask*)endRadarCall:(NSDictionary*)parameters completionBlock:(CompletionBlock)completionBlock;

// Images
- (NSURLSessionDataTask*)uploadImageCall:(NSDictionary*)parameters completionBlock:(CompletionBlock)completionBlock;
- (NSURLSessionDataTask*)getImageCall:(NSDictionary*)parameters completionBlock:(CompletionBlock)completionBlock;

// Contacts
- (NSURLSessionDataTask*)uploadContactCall:(NSDictionary*)parameters completionBlock:(CompletionBlock)completionBlock;



@end
