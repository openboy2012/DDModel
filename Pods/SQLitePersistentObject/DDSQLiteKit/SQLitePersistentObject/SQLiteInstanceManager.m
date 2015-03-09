//
//  SQLiteInstanceManager.m
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

#import "SQLiteInstanceManager.h"
#import "SQLitePersistentObject.h"


#pragma mark Private Method Declarations
@interface SQLiteInstanceManager (private)
- (NSString *)databaseFilepath;
@end

@implementation SQLiteInstanceManager

@synthesize databaseFilepath, databaseName;

#pragma mark -
#pragma mark Singleton Methods
+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    static SQLiteInstanceManager *sharedSQLiteManager = nil;
    dispatch_once(&onceToken, ^{
        sharedSQLiteManager = [[self alloc] init];
        sharedSQLiteManager.dbEvents = [[NSMutableArray alloc] initWithCapacity:0];
    });
    return sharedSQLiteManager;
}

#pragma mark -
#pragma mark Public Instance Methods
- (sqlite3 *)database
{
    static BOOL first = YES;
    
    if (first || database == NULL)
    {
        first = NO;
        if (!sqlite3_open([[self databaseFilepath] UTF8String], &database) == SQLITE_OK)
        {
            // Even though the open failed, call close to properly clean up resources.
            NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(database));
            sqlite3_close(database);
        }
        else
        {
            // Default to UTF-8 encoding
            [self executeUpdateSQL:@"PRAGMA encoding = \"UTF-8\""];
            
            // Turn on full auto-vacuuming to keep the size of the database down
            // This setting can be changed per database using the setAutoVacuum instance method
            [self executeUpdateSQL:@"PRAGMA auto_vacuum=1"];
            
        }
    }
    return database;
}

- (BOOL)tableExists:(NSString *)tableName
{
    BOOL ret = NO;
    // pragma table_info(i_c_project);
    NSString *query = [NSString stringWithFormat:@"pragma table_info(%@);", tableName];
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2( database,  [query UTF8String], -1, &stmt, nil) == SQLITE_OK) {
        if (sqlite3_step(stmt) == SQLITE_ROW)
            ret = YES;
        sqlite3_finalize(stmt);
    }
    return ret;
}

- (void)setAutoVacuum:(SQLITE3AutoVacuum)mode
{
    NSString *updateSQL = [NSString stringWithFormat:@"PRAGMA auto_vacuum=%d", mode];
    [self executeUpdateSQL:updateSQL];
}

- (void)setCacheSize:(NSUInteger)pages
{
    NSString *updateSQL = [NSString stringWithFormat:@"PRAGMA cache_size=%lu",(unsigned long)pages];
    [self executeUpdateSQL:updateSQL];
}

- (void)setLockingMode:(SQLITE3LockingMode)mode
{
    NSString *updateSQL = [NSString stringWithFormat:@"PRAGMA locking_mode=%d", mode];
    [self executeUpdateSQL:updateSQL];
}

- (void)deleteDatabase
{
    if(self.dbEvents.count > 0){
        dispatch_async(ddkit_db_queue(), ^{
            NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
            [dictionary setObject:self forKey:@"object"];
            SEL methodSEL = @selector(doDeleteDatabase);
            [dictionary setObject:[NSValue valueWithBytes:&methodSEL objCType:@encode(SEL)] forKey:@"performMethod"];
            [dictionary setObject:@"removeAllObjects" forKey:@"params"];
            [self.dbEvents insertObject:dictionary atIndex:0];
        });
        return;
    }
    [self doDeleteDatabase];
}

- (void)doDeleteDatabase{
    NSString *path = [self databaseFilepath];
    NSFileManager *fm = [NSFileManager defaultManager];
    [fm removeItemAtPath:path error:NULL];
    database = NULL;
    [SQLitePersistentObject clearCache];
}

- (void)vacuum
{
    [self executeUpdateSQL:@"VACUUM"];
}

- (void)executeUpdateSQL:(NSString *)updateSQL
{
    if([self.dbEvents count] > 0){
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
        [dictionary setObject:self forKey:@"object"];
        SEL methodSEL = @selector(executeUpdateSQLWithSQLString:);
        [dictionary setObject:[NSValue valueWithBytes:&methodSEL objCType:@encode(SEL)] forKey:@"performMethod"];
        [dictionary setObject:updateSQL?:@"" forKey:@"params"];
        [self.dbEvents insertObject:dictionary atIndex:0];
        return;
    }
    [self executeUpdateSQLWithSQLString:updateSQL];
}

- (void)executeUpdateSQLWithSQLString:(NSString *)sqlString{
    char *errorMsg;
    if (sqlite3_exec([self database],[sqlString UTF8String] , NULL, NULL, &errorMsg) != SQLITE_OK) {
        __unused NSString *errorMessage = [NSString stringWithFormat:@"Failed to execute SQL '%@' with message '%s'.", sqlString, errorMsg];
        NSAssert(0, errorMessage);
        sqlite3_free(errorMsg);
    }
}

#pragma mark -  Private Methods

- (NSString *)databaseFilepath
{
    NSAssert(self.databaseName != nil, @"You must specify a databaseName for non-shared instances");
    if (!databaseFilepath) {
#if (TARGET_OS_COCOTRON)
        databaseFilepath = [@"./" stringByAppendingPathComponent:self.databaseName];
#elif (TARGET_OS_MAC && ! TARGET_OS_IPHONE)
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
        NSString *base = ([paths count] > 0) ? [paths objectAtIndex:0] : NSTemporaryDirectory();
        databaseFilepath = [base stringByAppendingPathComponent:self.databaseName];
#else
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        databaseFilepath = [[paths objectAtIndex:0] stringByAppendingPathComponent:self.databaseName];
#endif
    }
    return databaseFilepath;
}

- (NSString *)databaseName
{
    if (!databaseName && self == [SQLiteInstanceManager sharedManager]) {
        NSMutableString *ret = [NSMutableString string];
        NSString *appName = [[NSProcessInfo processInfo] processName];
        for (int i = 0; i < [appName length]; i++) {
            NSRange range = NSMakeRange(i, 1);
            NSString *oneChar = [appName substringWithRange:range];
            if (![oneChar isEqualToString:@" "]) 
                [ret appendString:[oneChar lowercaseString]];
        }
        databaseName = [ret stringByAppendingString:@".sqlite3"];
    }
    return databaseName;
}

@end
