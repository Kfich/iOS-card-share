#import "Connection.h"
#import "ConnectionURLS.h"
#import "NSData+PKCS12.h"
#import "JSONResponseSerializerWithData.h"
#import "AFNetworking.h"

@interface Connection()

@property (nonatomic,strong) NSURLSessionConfiguration *sessionConfiguration;
@property (nonatomic,strong) AFHTTPSessionManager *sessionManager;

@end

@implementation Connection

#pragma mark - Initialization

- (id)initWithConfiguration:(NSURLSessionConfiguration*)sessionConfiguration {
    self = [super init];
    if (self) {
        if (!sessionConfiguration) {
            sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        }
        
        self.sessionConfiguration = sessionConfiguration;
        self.sessionManager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:self.sessionConfiguration];
        self.sessionManager.responseSerializer = [JSONResponseSerializerWithData serializer];
        return self;
    }
    return nil;
}

#pragma mark - Offers

// User
- (NSURLSessionDataTask*)createUserCall:(NSDictionary*)parameters completionBlock:(CompletionBlock)completionBlock {
    NSLog(@"%@",parameters);
    return [self genericPostCall:parameters completionBlock:completionBlock urlString:kCreateUser];
}

- (NSURLSessionDataTask*)updateUserCall:(NSDictionary*)parameters userID:(NSString*)userID completionBlock:(CompletionBlock)completionBlock {
    return [self genericPostCall:parameters completionBlock:completionBlock urlString:kUserUpdate];
}

- (NSURLSessionDataTask*)getUserCall:(NSDictionary*)parameters userID:(NSString*)userID completionBlock:(CompletionBlock)completionBlock {
    return [self genericPostCall:parameters completionBlock:completionBlock urlString:kGetUser];
}


// Cards
- (NSURLSessionDataTask*)createCardCall:(NSDictionary*)parameters completionBlock:(CompletionBlock)completionBlock {
    return [self genericPostCall:parameters completionBlock:completionBlock urlString:kCreateCard];
}

- (NSURLSessionDataTask*)getCardsCall:(NSDictionary*)parameters userID:(NSString*)userID completionBlock:(CompletionBlock)completionBlock {
    return [self genericPostCall:parameters completionBlock:completionBlock urlString:kGetCard];
}

- (NSURLSessionDataTask*)updateCardCall:(NSDictionary*)parameters cardID:(NSString*)cardID completionBlock:(CompletionBlock)completionBlock {
    return [self genericPostCall:parameters completionBlock:completionBlock urlString:kUpdateCard];
}


// Transactions
- (NSURLSessionDataTask*)createTransactionCall:(NSDictionary*)parameters completionBlock:(CompletionBlock)completionBlock {
    return [self genericPostCall:parameters completionBlock:completionBlock urlString:kCreateCard];
}

- (NSURLSessionDataTask*)getTransactionsCall:(NSDictionary*)parameters userID:(NSString*)userID completionBlock:(CompletionBlock)completionBlock {
    return [self genericPostCall:parameters completionBlock:completionBlock urlString:kGetTransaction];
}

- (NSURLSessionDataTask*)updateTransactionCall:(NSDictionary*)parameters transactionID:(NSString*)transactionID completionBlock:(CompletionBlock)completionBlock {
    return [self genericPostCall:parameters completionBlock:completionBlock urlString:kUpdateTransaction];
}


// Auth
- (NSURLSessionDataTask*)logoutCall:(NSDictionary*)parameters userID:(NSString*)userID completionBlock:(CompletionBlock)completionBlock {
    return [self genericPutCall:parameters completionBlock:completionBlock urlString: kLogoutUser];
}

- (NSURLSessionDataTask*)refreshTokenCall:(NSDictionary*)parameters userID:(NSString*)userID completionBlock:(CompletionBlock)completionBlock {
    return [self genericPostCall:parameters completionBlock:completionBlock urlString:kRefreshUserToken];
}



#pragma mark - Response Handling

- (void)connectionSuccess:(CompletionBlock)completionBlock responseObject:(id)responseObject {
    if(completionBlock) completionBlock(responseObject,nil);
}

- (void)connectionFail:(CompletionBlock)completionBlock
                  task:(NSURLSessionDataTask *)task
                 error:(NSError *)error {
    
    [self logConnectionError:error task:task];
    
    if(completionBlock) completionBlock(nil, error);
}

- (void)logConnectionError:(NSError *)error task:(NSURLSessionDataTask *)task {
    NSLog(@"[Connection] Status Code: %@, Body: %@", [Connection errorStatusCode:error], [Connection errorBody:error]);
}

+ (NSNumber *)errorStatusCode:(NSError *)error {
    return [error.userInfo objectForKey:kJSONStatusCodeKey];
}

+ (NSDictionary *)errorBody:(NSError *)error {
    return [error.userInfo objectForKey:kJSONBodyKey];
}



#pragma mark - Request Handling


- (NSURLSessionDataTask*)genericGetCall:(NSDictionary*)parameters
                        completionBlock:(CompletionBlock)completionBlock
                              urlString:(NSString*)urlString {
    
    return [self.sessionManager GET:urlString parameters:parameters
                            success:^(NSURLSessionDataTask *task, id responseObject) {
                                [self connectionSuccess:completionBlock responseObject:responseObject];
                            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                [self connectionFail:completionBlock task:task error:error];
    }];
}

- (NSURLSessionDataTask*)genericPutCall:(NSDictionary*)parameters
                        completionBlock:(CompletionBlock)completionBlock
                              urlString:(NSString*)urlString {
    
    return [self.sessionManager PUT:urlString
                         parameters:parameters
                            success:^(NSURLSessionDataTask *task, id responseObject) {
                                [self connectionSuccess:completionBlock responseObject:responseObject];
                            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                [self connectionFail:completionBlock task:task error:error];
                            }];
}

- (NSURLSessionDataTask*)genericPostCall:(NSDictionary*)parameters
                         completionBlock:(CompletionBlock)completionBlock
                               urlString:(NSString*)urlString {
    
    return [self.sessionManager POST:urlString parameters:parameters
                                                 success:^(NSURLSessionDataTask *task, id responseObject) {
                                                     [self connectionSuccess:completionBlock responseObject:responseObject];
                                                 } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                     [self connectionFail:completionBlock task:task error:error];
                                                 }];
}

- (NSURLSessionDataTask*)genericDeleteCall:(NSDictionary*)parameters
                           completionBlock:(CompletionBlock)completionBlock
                                 urlString:(NSString*)urlString {
    
    return [self.sessionManager DELETE:urlString
                            parameters:parameters
                               success:^(NSURLSessionDataTask *task, id responseObject) {
                                   [self connectionSuccess:completionBlock responseObject:responseObject];
                               } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                   [self connectionFail:completionBlock task:task error:error];
                               }];
}

@end