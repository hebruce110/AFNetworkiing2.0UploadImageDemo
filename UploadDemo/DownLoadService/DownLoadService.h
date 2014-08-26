//
//  DownLoadService.h
//  UploadDemo
//
//  Created by yuan on 14-8-26.
//  Copyright (c) 2014年 www.heyuan110.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownLoadService : NSObject

+ (void)addURL:(NSString *)urlString
    saveToPath:(NSString *)destinationPath
        result:(void (^)(BOOL isSucessed,NSString *url))callBackBlock;

@end
