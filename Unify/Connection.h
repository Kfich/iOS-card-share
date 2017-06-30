#import <Foundation/Foundation.h>

typedef void(^CompletionBlock)(id dictionary, NSError *error);

@interface Connection : NSObject

- (id)initWithConfiguration:(NSURLSessionConfiguration*)sessionConfiguration;
+ (NSNumber *)errorStatusCode:(NSError *)error;
+ (NSDictionary *)errorBody:(NSError *)error;

// Users
- (NSURLSessionDataTask*)createUserCall:(NSDictionary*)parameters completionBlock:(CompletionBlock)completionBlock;
- (NSURLSessionDataTask*)getUserCall:(NSDictionary*)parameters userID:(NSString*)userID completionBlock:(CompletionBlock)completionBlock;
- (NSURLSessionDataTask*)updateUserCall:(NSDictionary*)parameters userID:(NSString*)userID completionBlock:(CompletionBlock)completionBlock;

// Cards
- (NSURLSessionDataTask*)createCardCall:(NSDictionary*)parameters completionBlock:(CompletionBlock)completionBlock;
- (NSURLSessionDataTask*)getCardsCall:(NSDictionary*)parameters userID:(NSString*)userID completionBlock:(CompletionBlock)completionBlock;
- (NSURLSessionDataTask*)updateCardCall:(NSDictionary*)parameters cardID:(NSString*)cardID completionBlock:(CompletionBlock)completionBlock;

// Transactions
- (NSURLSessionDataTask*)createTransactionCall:(NSDictionary*)parameters completionBlock:(CompletionBlock)completionBlock;
- (NSURLSessionDataTask*)getTransactionsCall:(NSDictionary*)parameters userID:(NSString*)userID completionBlock:(CompletionBlock)completionBlock;
- (NSURLSessionDataTask*)updateTransactionCall:(NSDictionary*)parameters transactionID:(NSString*)transactionID completionBlock:(CompletionBlock)completionBlock;

// Auth
- (NSURLSessionDataTask*)logoutCall:(NSDictionary*)parameters userID:(NSString*)userID completionBlock:(CompletionBlock)completionBlock;
- (NSURLSessionDataTask*)refreshTokenCall:(NSDictionary*)parameters userID:(NSString*)userID completionBlock:(CompletionBlock)completionBlock;



@end
