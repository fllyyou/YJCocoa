//
//  YJSingletonMCenter.h
//  YJFoundation
//
//  HomePage:https://github.com/937447974/YJCocoa
//  YJ技术支持群:557445088
//
//  Created by 阳君 on 16/5/25.
//  Copyright © 2016年 YJ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/** 快速获取单例管理中心*/
#define YJSingletonMC [YJSingletonMCenter defaultCenter]

/** 单例管理中心*/
@interface YJSingletonMCenter : NSObject

#pragma mark 获取默认
/**
 *  获取默认的单例中心
 *
 *  @return YJSingletonCenter
 */
+ (YJSingletonMCenter *)defaultCenter;

#pragma mark 注册strong单例
/**
 *  注册strong单例（随应用一直存在）
 *
 *  @param sClass 单例类
 *
 *  @return singleton
 */
- (id)registerStrongSingleton:(Class)sClass;

/**
 *  注册strong单例（随应用一直存在）
 *
 *  @param sClass 单例类
 *  @param identifier 自定义标签
 *
 *  @return singleton
 */
- (id)registerStrongSingleton:(Class)sClass forIdentifier:(NSString *)identifier;

#pragma mark 注册weak单例
/**
 *  注册weak单例（内存警告时回收）
 *
 *  @param sClass 单例类
 *
 *  @return singleton
 */
- (id)registerWeakSingleton:(Class)sClass;

/**
 *  注册weak单例（内存警告时回收）
 *
 *  @param sClass 单例类
 *  @param identifier 自定义标签
 *
 *  @return singleton
 */
- (id)registerWeakSingleton:(Class)sClass forIdentifier:(NSString *)identifier;

#pragma mark 移除weak单例
/**
 *  通过类移除weak单例
 *
 *  @param sClass 单例类
 *
 *  @return void
 */
- (void)removeWeakSingleton:(Class)sClass;

/**
 *  通过自定义标签移除weak单例
 *
 *  @param sClass 单例类
 *
 *  @return void
 */
- (void)removeWeakSingletonWithIdentifier:(NSString *)identifier;

@end

NS_ASSUME_NONNULL_END
