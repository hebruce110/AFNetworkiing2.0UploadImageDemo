//
//  CCViewController.h
//  UploadDemo
//
//  Created by yuan on 14-8-11.
//  Copyright (c) 2014年 www.heyuan110.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *selectImageBtn;
@property (weak, nonatomic) IBOutlet UIButton *uploadBtn;

- (IBAction)upload:(id)sender;

- (IBAction)selectImage:(id)sender;

@end
