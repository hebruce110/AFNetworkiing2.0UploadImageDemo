//
//  CCViewController.m
//  UploadDemo
//
//  Created by yuan on 14-8-11.
//  Copyright (c) 2014年 www.heyuan110.com. All rights reserved.
//

#import "CCViewController.h"
#import "SVProgressHUD.h"
#import "AFDownloadRequestOperation.h"

@interface CCViewController ()

@end

@implementation CCViewController

- (AFHTTPRequestOperation *)downloadFileWithURL:(NSString *)url
                                    destination:(NSString*)destinationPath
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
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    /*
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:destinationPath append:NO];
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead)
     {
         float percentDone = (float)totalBytesRead/(float)totalBytesExpectedToRead;
         NSString *percentDoneString =  [NSString stringWithFormat:@"PERCENT:%.2f%%",percentDone*100];
         NSString *current = [NSString stringWithFormat:@"CURRENT:%.2fMB",(float)totalBytesRead/(1024*1024)];
         NSString *total = [NSString stringWithFormat:@"TOTAL:%.2fMB",(float)totalBytesExpectedToRead/(1024*1024)];
         HYLog(@"%@,%@,%@",total,current,percentDoneString);
     }];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"Successfully downloaded file to %@", destinationPath);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
     */
    return operation;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *urlString = @"http://source.fullteem.com/mp4/xpg.mp4";
    NSString *destinationPath = [PATH_OF_DOCUMENT stringByAppendingPathComponent:[urlString lastPathComponent]];
    AFHTTPRequestOperation *op = [self downloadFileWithURL:urlString destination:destinationPath];
    [[AFHTTPRequestOperationManager manager].operationQueue addOperation:op];
    
    /*
    NSURL *someLocalURL = [NSURL URLWithString:destinationPath];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    AFHTTPRequestOperation *operation = [manager GET:urlString
                                          parameters:nil
                                             success:^(AFHTTPRequestOperation *operation, NSData *responseData){
                                                 [responseData writeToFile:path atomically:YES];
//                                                 [responseData writeToURL:someLocalURL atomically:YES];
                                             }
                                             failure:^(AFHTTPRequestOperation *operation, NSError *error)
                                         {
                                             NSLog(@"Downloading error: %@", error);
                                         }];
    
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead)
     {
         float percentDone = (float)totalBytesRead/(float)totalBytesExpectedToRead;
         NSString *percentDoneString =  [NSString stringWithFormat:@"PERCENT:%.2f%%",percentDone*100];
         NSString *current = [NSString stringWithFormat:@"CURRENT:%.2fMB",(float)totalBytesRead/(1024*1024)];
         NSString *total = [NSString stringWithFormat:@"TOTAL:%.2fMB",(float)totalBytesExpectedToRead/(1024*1024)];
         HYLog(@"%@,%@,%@",total,current,percentDoneString);
     }];
    */
    
    /*
    NSString *url = @"http://source.fullteem.com/mp4/xpg.mp4";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    NSString *path = [PATH_OF_DOCUMENT stringByAppendingPathComponent:[url lastPathComponent]];
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:path append:NO];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"Successfully downloaded file to %@", path);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        float percentDone = totalBytesRead/(float)totalBytesExpectedToRead;
        NSString *percentDoneString =  [NSString stringWithFormat:@"PERCENT:%.2f%%",percentDone*100];
        NSString *current = [NSString stringWithFormat:@"CURRENT:%.2fMB",(CGFloat)totalBytesRead/(1024*1024)];
        NSString *total = [NSString stringWithFormat:@"TOTAL:%.2fMB",(CGFloat)totalBytesExpectedToRead/(1024*1024)];
        HYLog(@"%@,%@,%@",total,current,percentDoneString);
    }];
    [operation start];
     */
}

- (IBAction)upload:(id)sender
{
    UIImage *image = _selectImageBtn.currentBackgroundImage;
    NSAssert(image, @"#错误：未选择图片");
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];  //添加ContentType识别text/plain，默认只识别text/json
    NSDictionary *parameters = @{@"param": [@{@"filename": @"test"} toJsonString]};
    NSString *url = @"http://117.41.229.155:805/WS/WS_Services.ashx?action=imgupload";
    AFHTTPRequestOperation *operation = [manager POST:url
                                           parameters:parameters
                            constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 0.5) name:@"imgfile" fileName:@"test.png" mimeType:@"image/jpeg"];
                            } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                HYLog(@"%@-----%@",operation.responseString,responseObject);
                                if (isValidDictionary(responseObject) && [responseObject[@"error"] integerValue] == 0) {
                                    [SVProgressHUD showSuccessWithStatus:VString(@"上传成功!")];                                 }else{
                                    [SVProgressHUD showErrorWithStatus:@"上传出错！"];
                                }
                            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                NSLog(@"Error: %@ ***** %@", operation.responseString, error);
                                [SVProgressHUD showErrorWithStatus:VString(@"上传失败!")];
                            }];
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        CGFloat percent = totalBytesWritten/(float)totalBytesExpectedToWrite;
        HYLog(@"上传进度...%f",percent);
        [SVProgressHUD showProgress:percent status:VString(@"正在上传")];
    }];
    [operation start];
}


- (IBAction)selectImage:(id)sender
{
    [[VPickImage sharedVPickImage]showActionSheet:^(UIImage *image, NSInteger index) {
        if (image) {
            [self.selectImageBtn setBackgroundColor:[UIColor clearColor]];
            [self.selectImageBtn setBackgroundImage:image forState:UIControlStateNormal];
            [self.selectImageBtn setTitle:nil forState:UIControlStateNormal];
        }
    } isEdit:YES delegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
