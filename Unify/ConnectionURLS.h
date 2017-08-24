#ifndef hole19_ConnectionURLS_h
#define hole19_ConnectionURLS_h


#define kServerURL(server, action) [NSString stringWithFormat: server, action]


// Test Server
//#define kAppwsServerURL @"https://project-unify-node-server.herokuapp.com/%@"

// Production Server
#define kAppwsServerURL @"https://project-unify-node-server-stag.herokuapp.com/%@"

// User
#define kCreateUser           kServerURL(kAppwsServerURL, @"user/create")
#define kGetUser              kServerURL(kAppwsServerURL, @"user/get")
#define kUserUpdate           kServerURL(kAppwsServerURL, @"user/update")
#define kGetUserList          kServerURL(kAppwsServerURL, @"user/getList")

// Cards
#define kCreateCard           kServerURL(kAppwsServerURL, @"card/create")
#define kGetCard              kServerURL(kAppwsServerURL, @"card/get")
#define kUpdateCard           kServerURL(kAppwsServerURL, @"card/update/")
#define kDeleteCard           kServerURL(kAppwsServerURL, @"card/delete")
// * Test
#define kGetSingleCard        kServerURL(kAppwsServerURL, @"card/getSingleCard")

// Transactions
#define kCreateTransaction    kServerURL(kAppwsServerURL, @"transaction/create")
#define kGetTransaction       kServerURL(kAppwsServerURL, @"transaction/get")
#define kUpdateTransaction    kServerURL(kAppwsServerURL, @"transaction/update")
#define kApproveTransaction   kServerURL(kAppwsServerURL, @"transaction/approve")
#define kRejectTransaction    kServerURL(kAppwsServerURL, @"transaction/reject")
#define kSearchTransactions   kServerURL(kAppwsServerURL, @"transaction/search")

// Auth
#define kLogoutUser           kServerURL(kAppwsServerURL, @"auth/logout")
#define kRefreshUserToken     kServerURL(kAppwsServerURL, @"auth/refreshToken")
#define kIssuePin             kServerURL(kAppwsServerURL, @"auth/issuePin")
#define kVerifyPin            kServerURL(kAppwsServerURL, @"auth/verifyPin")

// Geo
#define kStartRadar           kServerURL(kAppwsServerURL, @"startRadar")
#define kEndRadar             kServerURL(kAppwsServerURL, @"endRadar")


// Images
#define kUploadImages         kServerURL(kAppwsServerURL, @"image/uploadcdn")
#define kGetUserImage         kServerURL(kAppwsServerURL, @"image/%@")

// Contacts
#define kUploadContact        kServerURL(kAppwsServerURL, @"contacts/add")
#define kGetContacts          kServerURL(kAppwsServerURL, @"contacts/get")
#define kGetManyContacts      kServerURL(kAppwsServerURL, @"contacts/getMany")
#define kSearchContacts       kServerURL(kAppwsServerURL, @"contacts/search")
#define kDeleteContacts       kServerURL(kAppwsServerURL, @"contacts/deleteAll")


// Events
#define kUploadEvent          kServerURL(kAppwsServerURL, @"calendar/create")
#define kGetEvents            kServerURL(kAppwsServerURL, @"calendar/get")


// Badges
#define kGetBadges            kServerURL(kAppwsServerURL, @"corporate/getManyBadges")
#define kGetOrgCard           kServerURL(kAppwsServerURL, @"corporate/getOrgCard")


#endif
