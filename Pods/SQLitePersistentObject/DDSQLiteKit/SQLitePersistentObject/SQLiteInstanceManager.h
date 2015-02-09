//
//  SQLiteInstanceManager.h
// ----------------------------------------------------------------------
// Part of the SQLite Persistent Objects for Cocoa and Cocoa Touch
//
// Original Version: (c) 2008 Jeff LaMarche (jeff_Lamarche@mac.com)
// ----------------------------------------------------------------------
// This code may be used without restriction in any software, commercial,
// free, or otherwise. There are no attribution requirements, and no
// requirement that you distribute your changes, although bugfixes and
// enhancements are welcome.
//
// If you do choose to re-distribute the source code, you must retain the
// copyright notice and this license information. I also request that you
// place comments in to identify your changes.
//
// For information on how to use these classes, take a look at the
// included Readme.txt file
// ----------------------------------------------------------------------
#if (TARGET_OS_MAC && ! (TARGET_OS_EMBEDDED || TARGET_OS_ASPEN || TARGET_OS_IPHONE))
#import <Foundation/Foundation.h>
#else
#import <UIKit/UIKit.h>
#endif

#import <sqlite3.h>

#if (! TARGET_OS_IPHONE)
#import <objc/objc-runtime.h>
#else
#import <objc/runtime.h>
#import <objc/message.h>
#endif

/**
 *  Define db queue name by DeJohn Dong 2015-02-06
 *
 *  @return db queue name
 */
#define db_queue_name "com.ddkit.db.queue"

/**
 *  Singleton a dispatch_queue_t by DeJohn Dong 2015-02-16
 *
 *  @return a singleton dispatch_queue_t 'ddkit_db_queue'
 */
static __unused dispatch_queue_t ddkit_db_queue() {
    static dispatch_queue_t ddkit_db_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ddkit_db_queue = dispatch_queue_create(db_queue_name, DISPATCH_QUEUE_SERIAL);
    });
    return ddkit_db_queue;
}

typedef enum SQLITE3AutoVacuum
{
    kSQLITE3AutoVacuumNoAutoVacuum = 0,
    kSQLITE3AutoVacuumFullVacuum,
    kSQLITE3AutoVacuumIncrementalVacuum,
    
} SQLITE3AutoVacuum;

typedef enum SQLITE3LockingMode
{
    kSQLITE3LockingModeNormal = 0,
    kSQLITE3LockingModeExclusive,
} SQLITE3LockingMode;


@interface SQLiteInstanceManager : NSObject
{
@private
    NSString *databaseFilepath;
    NSString *databaseName;
    sqlite3 *database;
}

@property (nonatomic, readwrite, copy) NSString *databaseName;
@property (nonatomic, readwrite, copy) NSString *databaseFilepath;
// add by DeJohn Dong
@property (nonatomic, strong) NSMutableArray *dbEvents;

+ (id)sharedManager;
- (sqlite3 *)database;
- (BOOL)tableExists:(NSString *)tableName;
- (void)setAutoVacuum:(SQLITE3AutoVacuum)mode;
- (void)setCacheSize:(NSUInteger)pages;
- (void)setLockingMode:(SQLITE3LockingMode)mode;
- (void)deleteDatabase;
- (void)vacuum;
- (void)executeUpdateSQL:(NSString *)updateSQL;

@end
