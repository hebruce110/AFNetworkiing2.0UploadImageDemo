//
//  CCViewController.m
//  UploadDemo
//
//  Created by yuan on 14-8-11.
//  Copyright (c) 2014年 www.heyuan110.com. All rights reserved.
//

#import "CCViewController.h"
#import "SVProgressHUD.h"

@interface CCViewController ()

@end

@implementation CCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
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
