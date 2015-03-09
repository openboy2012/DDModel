# DDSQLiteKit
An ORM kit of object persistence use SQLite

##SQLitePersistentObject

SQLitePersistentObject is an ORM Kit Write by Jeff LaMarche, it's excellent.

Any class that subclasses this class can have their properties automatically persisted into a sqlite database. There are some limits - currently certain property types aren't supported like void *, char *, structs and unions. Anything that doesn't work correctly with Key Value Coding will not work with this. Ordinary scalars (ints, floats, etc) will be converted to NSNumber, as will BOOL.
 
 SQLite is very good about converting types, so you can search on a number field passing in a number in a string, and can search on a string field by passing in a number. The only limitation we place on the search methods is that we don't allow searching on blobs, which is simply for performance reasons. 
 
but now, Jeff not work on this library. so I will work on this library.
in original this library is non-safe-thread in multithread opearations , I just make it thread-safe in multithread use some new methods

##Installation

[![Version](http://cocoapod-badges.herokuapp.com/v/SQLitePersistentObject/badge.png)](http://cocoadocs.org/docsets/SQLitePersistentObject/) [![Platform](http://cocoapod-badges.herokuapp.com/p/SQLitePersistentObject/badge.png)](http://cocoadocs.org/docsets/SQLitePersistentObject/)   
FlickerNumber is available through [CocoaPods](http://cocoapods.org), to install
it simply add the following line to your Podfile:

    pod "SQLitePersistentObject"
Alternatively, you can just drag the files from `SQLitePersistentObject / SQLitePersistentObject` into your own project. 

## Usage

create an object inherit SQLitePersistentObject
```
header file:
#import "SQLitePersistentObject.h"

@interface Device : SQLitePersistentObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *model;
@property (nonatomic, strong) NSNumber *price;

@end


implementation file:
#import "Device.h"

@implementation Device

@end

```

## Methods
```
#pragma mark - DeJohn Dong Added Methods
/**
 *  Asynchronous add/update an object to db.
 */
- (void)save;

/**
 *  Asynchronous delete an object from db.
 */
- (void)asynDeleteObject;

/**
 *  Asynchronous delete an object and the cascade objects from db.
 */
- (void)asynDeleteObjectCascade:(BOOL)cascade;

/**
 *  Asynchronous Query the object list with criteria from db.
 *
 *  @param criteria criteria string
 *  @param result   result list
 */
+ (void)queryByCriteria:(NSString *)criteria result:(DBQueryResult)result;

/**
 *  Asynchronous Query the first object with criteria from db
 *
 *  @param criteria criteria string
 *  @param result   result object
 */
+ (void)queryFirstItemByCriteria:(NSString *)criteria result:(DBQueryResult)result;

/**
 *  Asynchronous Query all the objects from db
 *
 *  @param result result list
 */
+ (void)queryResult:(DBQueryResult)result;
```

## Requirements

- Xcode 6
- iOS 5.1.1 or Mac OSX 10.8

## Author

Jeff LaMarche jeff_Lamarche@mac.com / DeJohn Dong, dongjia_9251@126.com

## License

SQLitePersistentObject is available under the MIT license. See the LICENSE file for more info.
