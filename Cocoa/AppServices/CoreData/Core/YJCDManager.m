//
//  YJCDManager.m
//  YJCoreData
//
//  HomePage:https://github.com/937447974/YJCocoa
//  YJ技术支持群:557445088
//
//  Created by 阳君 on 2016/10/27.
//  Copyright © 2016年 YJCocoa. All rights reserved.
//

#import "YJCDManager.h"
#import "YJNSTimer.h"

@implementation YJCDManager

- (instancetype)init {
    self = [super init];
    if (self) {
        // Core Data
        self.model = [NSManagedObjectModel mergedModelFromBundles:nil];
        self.coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.model];
        self.rootContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [self.rootContext performBlockAndWait:^{
            self.rootContext.persistentStoreCoordinator = self.coordinator;
            self.rootContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;
        }];
        self.mainContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        self.mainContext.parentContext = self.rootContext;
        self.mainContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;
        // Notification
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(saveAuto) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [nc addObserver:self selector:@selector(saveAuto) name:UIApplicationWillTerminateNotification object:nil];
    }
    return self;
}

#pragma mark getter & setter
- (void)setAutoSaveInterval:(NSTimeInterval)autoSaveInterval {
    _autoSaveInterval = autoSaveInterval;
    YJNSTimer *timer = [YJNSTimer timerStrongWithIdentifier:@"YJCDManager"];
    if (autoSaveInterval > 0) {
        [timer addTarget:self action:@selector(saveAuto)];
        timer.timeInterval = autoSaveInterval;
        [timer run];
    } else {
        [timer invalidate];
    }
}

#pragma mark - setup
- (YJCDMSetup)setupWithStoreURL:(NSURL *)storeURL error:(NSError * _Nullable __autoreleasing *)error {
    if (self.store) {
        return YJCDMSetupSuccess;
    }
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL result = YES;
    BOOL migration = YES;
    NSError *resultError = nil;
    _storeURL = storeURL;
    if ([fm fileExistsAtPath:storeURL.path]) {
        NSDictionary *sourceMetadata = [NSPersistentStoreCoordinator metadataForPersistentStoreOfType:NSSQLiteStoreType URL:storeURL options:nil error:&resultError];
        result = sourceMetadata.count;
        if (result) {
            migration = [self.model isConfiguration:nil compatibleWithStoreMetadata:sourceMetadata];
            resultError = migration ? nil : [NSError errorWithDomain:@"持久化存储区需要迁移升级，可使用YJCDMigrationManager做迁移升级！" code:YJCDMSetupMigration userInfo:nil];
        }
    } else {
        NSURL *storeDirectory = storeURL.URLByDeletingLastPathComponent;
        if (![fm fileExistsAtPath:storeDirectory.path]) {
            result = [fm createDirectoryAtURL:storeDirectory withIntermediateDirectories:YES attributes:nil error:&resultError];
        }
    }
    if (result && migration) {
        _store = [_coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&resultError];
    }
    if (resultError) {
        if (error) {
            *error = resultError;
        }
        return migration ? YJCDMSetupError : YJCDMSetupMigration;
    }
    return YJCDMSetupSuccess;
}

#pragma mark - save
- (BOOL)saveInMemory:(NSError * _Nullable __autoreleasing *)error {
    if (!self.store) {
        if (error) {
            *error = [NSError errorWithDomain:@"数据库未设置" code:888 userInfo:nil];
        }
        return NO;
    }
    if (self.mainContext.hasChanges) {
        return [self.mainContext save:error];
    }
    return YES;
}

- (void)saveInStore:(void (^)(BOOL, NSError *))block {
    __block NSError *error;
    [self saveInMemory:&error];
    if (!error) {
        [self.rootContext performBlock:^{
            BOOL result = YES;
            if (self.rootContext.hasChanges) {
                result = [self.rootContext save:&error];
            }
            if (block) {
                block(result, error);
            }
        }];
    } else if (block) {
        block(NO, error);
    }
}

- (void)saveAuto {
    [self saveInStore:^(BOOL success, NSError * _Nonnull error) {
        if (success) {
            NSLog(@"YJCoreData自动化保存数据库成功");
        } else {
            NSLog(@"YJCoreData自动化保存数据库失败:%@", error);
        }
    }];
}

@end
