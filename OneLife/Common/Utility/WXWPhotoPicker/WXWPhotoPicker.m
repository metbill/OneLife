//
//  WXWPhotoPicker.m
//  wxw
//
//  Created by wxw on 16/7/4.
//  Copyright © 2016年 wxw. All rights reserved.
//

#import "WXWPhotoPicker.h"
#import <AVFoundation/AVFoundation.h>

#define kGlobalThread dispatch_get_global_queue(0, 0)
#define kMainThread   dispatch_get_main_queue()

#define kIsIOS7OrLater ([UIDevice currentDevice].systemVersion.floatValue>=7.0)

@interface UIImagePickerController(Photo)

+(BOOL)isCameraAvailable;
+(BOOL)isPhotoLibraryAvailable;
+(BOOL)canTakePhoto;

@end

@interface WXWPhotoPicker()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, weak)     UIViewController  *fromController;
@property (nonatomic, copy)     CompletionBlock   completion;
@property (nonatomic, copy)     CancelBlock       cancelBlock;
@property (nonatomic, assign)   BOOL              allowImgEdit;

@end

@implementation WXWPhotoPicker

+ (WXWPhotoPicker *)sharedPhotoPicker{
    static WXWPhotoPicker *sharedObject = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        if (!sharedObject) {
            sharedObject = [[[self class] alloc] init];
        }
    });
    
    return sharedObject;
}


- (void)showActionSheetInView:(UIView *)inView
               fromController:(UIViewController *)fromController
                 allowImgEdit:(BOOL)allowImgEdit
                   completion:(CompletionBlock)completion
                  cancelBlock:(CancelBlock)cancelBlock{
    self.completion = [completion copy];
    self.cancelBlock = [cancelBlock copy];
    self.fromController = fromController;
    self.allowImgEdit = allowImgEdit;
    
    dispatch_async(kGlobalThread, ^{
        UIActionSheet *actionSheet = nil;
        if ([UIImagePickerController isCameraAvailable]) {
            actionSheet  = [[UIActionSheet alloc] initWithTitle:nil
                                                       delegate:(id<UIActionSheetDelegate>)self
                                              cancelButtonTitle:@"取消"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"从相册选择", @"拍照上传", nil];
        } else {
            actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                      delegate:(id<UIActionSheetDelegate>)self
                                             cancelButtonTitle:@"取消"
                                        destructiveButtonTitle:nil
                                             otherButtonTitles:@"从相册选择", nil];
        }
        
        dispatch_async(kMainThread, ^{
            [actionSheet showInView:inView];
        });
    });
}

#pragma mark - Private

- (BOOL)isHaveCameraAuthorization{
    if ([[AVCaptureDevice class] respondsToSelector:@selector(authorizationStatusForMediaType:)]) {
        AVAuthorizationStatus authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authorizationStatus == AVAuthorizationStatusRestricted
            || authorizationStatus == AVAuthorizationStatusDenied) {
            
            // 没有权限
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                message:@"不能访问相机，请在(设置-隐私-相机)中允许访问!"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView show];
            return NO;
        }
    }
    
    return YES;
}

#pragma mark - Delegatge
#pragma mark __UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.allowsEditing = self.allowImgEdit;
    if (buttonIndex == 0) { // 从相册选择
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    else if (buttonIndex == 1) { // 拍照

        if ([UIImagePickerController canTakePhoto]) {
            
            if( [self isHaveCameraAuthorization] == NO ){
                return;
            }
            
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            
        }else{
            return;
        }
    }
    else if( buttonIndex == 2 ){
        return;
    }

    picker.delegate = self;
    if (kIsIOS7OrLater) {
        picker.navigationBar.barTintColor = self.fromController.navigationController.navigationBar.barTintColor;
    }
    // 设置导航默认标题的颜色及字体大小
    picker.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],
                                                 NSFontAttributeName : [UIFont boldSystemFontOfSize:18]};
    [self.fromController presentViewController:picker animated:YES completion:nil];
}


#pragma mark __UIImagePickerControllerDelegate
// 选择了图片或者拍照了
- (void)imagePickerController:(UIImagePickerController *)aPicker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [aPicker dismissViewControllerAnimated:YES completion:nil];
    __block UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
    if( image == nil )
        image = info[UIImagePickerControllerOriginalImage];
    
    if (image && self.completion) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        [self.fromController setNeedsStatusBarAppearanceUpdate];
        
        if( image && self.completion ){
            self.completion(@[image]);
        }
    }
}

// 取消
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)aPicker {
    [aPicker dismissViewControllerAnimated:YES completion:nil];
    
    if (self.cancelBlock) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        [self.fromController setNeedsStatusBarAppearanceUpdate];
        
        self.cancelBlock();
    }
    [aPicker dismissViewControllerAnimated:YES completion:nil];
}


@end


@implementation UIImagePickerController(photo)
+(BOOL)isCameraAvailable
{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]            //后置摄像头
    ||
    [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];          //前置摄像头
}

+(BOOL)isPhotoLibraryAvailable
{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
}

+(BOOL)canTakePhoto
{
    return [UIImagePickerController isCameraAvailable];
}
@end


