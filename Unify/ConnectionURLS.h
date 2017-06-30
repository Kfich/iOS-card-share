#ifndef hole19_ConnectionURLS_h
#define hole19_ConnectionURLS_h

#define kServerURL(server, action) [NSString stringWithFormat: server, action]

#define kAppwsServerURL @"https://project-unify-node-server.herokuapp.com/%@"

// User
#define kCreateUser               kServerURL(kAppwsServerURL, @"user/create")
#define kGetUser              kServerURL(kAppwsServerURL, @"user/get")
#define kUserUpdate           kServerURL(kAppwsServerURL, @"user/update")

// Cards
#define kCreateCard           kServerURL(kAppwsServerURL, @"cards/create")
#define kGetCard              kServerURL(kAppwsServerURL, @"cards/get")
#define kUpdateCard           kServerURL(kAppwsServerURL, @"cards/update/")

// Transactions
#define kCreateTransaction    kServerURL(kAppwsServerURL, @"transactions/create")
#define kGetTransaction       kServerURL(kAppwsServerURL, @"transactions/get")
#define kUpdateTransaction    kServerURL(kAppwsServerURL, @"transactions/update")

// Auth
#define kLogoutUser         kServerURL(kAppwsServerURL, @"auth/logout")
#define kRefreshUserToken   kServerURL(kAppwsServerURL, @"auth/refreshToken")


#endif
