//
//  DownLoadService.m
//  UploadDemo
//
//  Created by yuan on 14-8-26.
//  Copyright (c) 2014年 www.heyuan110.com. All rights reserved.
//

#import "DownLoadService.h"
#import "AFDownloadRequestOperation.h"

@implementation DownLoadService

+ (AFHTTPRequestOperation *)downloadFileWithURL:(NSString *)url
                                    destination:(NSString*)destinationPath
                                         result:(void (^)(BOOL isSucessed,NSString *url))callBackBlock
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    AFDownloadRequestOperation *operation = [[AFDownloadRequestOperation alloc]initWithRequest:request targetPath:destinationPath shouldResume:YES];
    [operation setProgressiveDownloadProgressBlock:^(AFDownloadRequestOperation *operation, NSInteger bytesRead, long long totalBytesRead, long long totalBytesExpected, long long totalBytesReadForFile, long long totalBytesExpectedToReadForFile) {
        float percentDone = (float)totalBytesReadForFile/(float)totalBytesExpectedToReadForFile;
        NSString *percentDoneString =  [NSString stringWithFormat:@"PERCENT:%.2f%%",percentDone*100];
        NSString *current = [NSString stringWithFormat:@"CURRENT:%.2fMB",(float)totalBytesRead/(1024*1024)];
        NSString *total = [NSString stringWithFormat:@"TOTAL:%.2fMB",(float)totalBytesExpectedToReadForFile/(1024*1024)];
        HYLog(@"%@,%@,%@",total,current,percentDoneString);
    }];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"Successfully downloaded file to %@", destinationPath);
        callBackBlock(YES,url);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        callBackBlock(NO,url);
    }];
    return operation;
}

+ (void)addURL:(NSString *)urlString
    saveToPath:(NSString *)destinationPath
        result:(void (^)(BOOL isSucessed,NSString *url))callBackBlock
{
//    NSString *urlString = @"http://source.fullteem.com/mp4/xpg.mp4";  //test
//    NSString *destinationPath = [PATH_OF_DOCUMENT stringByAppendingPathComponent:[urlString lastPathComponent]];
    AFHTTPRequestOperation *op = [DownLoadService downloadFileWithURL:urlString destination:destinationPath result:callBackBlock];
    [[AFHTTPRequestOperationManager manager].operationQueue addOperation:op];
}

@end
