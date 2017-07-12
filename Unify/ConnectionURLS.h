#ifndef hole19_ConnectionURLS_h
#define hole19_ConnectionURLS_h

#define kServerURL(server, action) [NSString stringWithFormat: server, action]

#define kAppwsServerURL @"https://project-unify-node-server.herokuapp.com/%@"

// User
#define kCreateUser               kServerURL(kAppwsServerURL, @"user/create")
#define kGetUser              kServerURL(kAppwsServerURL, @"user/get")
#define kUserUpdate           kServerURL(kAppwsServerURL, @"user/update")

// Cards
#define kCreateCard           kServerURL(kAppwsServerURL, @"card/create")
#define kGetCard              kServerURL(kAppwsServerURL, @"card/get")
#define kUpdateCard           kServerURL(kAppwsServerURL, @"card/update/")

// Transactions
#define kCreateTransaction    kServerURL(kAppwsServerURL, @"transactions/create")
#define kGetTransaction       kServerURL(kAppwsServerURL, @"transactions/get")
#define kUpdateTransaction    kServerURL(kAppwsServerURL, @"transactions/update")

// Add
#define kApproveTransaction   kServerURL(kAppwsServerURL, @"transactions/approve")
#define kRejectTransaction    kServerURL(kAppwsServerURL, @"transactions/reject")

// Auth
#define kLogoutUser           kServerURL(kAppwsServerURL, @"auth/logout")
#define kRefreshUserToken     kServerURL(kAppwsServerURL, @"auth/refreshToken")

// Add
#define kIssuePin             kServerURL(kAppwsServerURL, @"auth/issuePin")
#define kVerifyPin            kServerURL(kAppwsServerURL, @"auth/verifyPin")



#endif
