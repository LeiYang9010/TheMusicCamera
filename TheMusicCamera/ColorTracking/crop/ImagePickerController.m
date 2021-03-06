//
//  ImagePickerController.m
//  CropImage
//
//  Created by yanglei on 14-1-8.
//  Copyright (c) 2014年 yanglei. All rights reserved.
//

#import "ImagePickerController.h"
#import "VPImageCropperViewController.h"

@interface ImagePickerController ()
{
//  UIImageView* imageView;
}

@end
@implementation ImagePickerController
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [UIApplication sharedApplication].statusBarHidden=YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [UIApplication sharedApplication].statusBarHidden=YES;

//  imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 50, 300, 300)];
//  [self.view addSubview:imageView];
//  
//  UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(110, 400, 100, 20)];
//  [btn setTitle:@"Select Image" forState:UIControlStateNormal];
//  [btn setTitleColor:[UIColor blackColor] forState: UIControlStateNormal];
//  [btn addTarget:self action:@selector(selectImage:) forControlEvents:UIControlEventTouchUpInside];
//  [self.view addSubview:btn];
}

-(void) selectImage:(id) sender
{
  [self begin];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) presentCropper:(UIImage*) image
{
//  cropper = [[ImaeCropper alloc] initWithImage:image];
//  cropper.delegate = self;
//  [self.navigationController pushViewController:cropper animated:YES];
//  [self presentViewController:cropper animated:YES completion:^{}];
//  [self.view addSubview:cropper.view];
//  
//   UIImage* portraitImg = [self imageByScalingToMaxSize:image];
//  // 裁剪
//  VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
//  imgEditorVC.delegate = self;
}

-(void) begin
{
  UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
  imagePicker.delegate = self;
  imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
  imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
  imagePicker.allowsEditing = NO;
  [self presentModalViewController:imagePicker animated:YES];
}

-(void) didCropImage:(UIImage *)image
{
//  imageView.image = image;
  [delegate didFinishImagePickerAndCrop:image];
}

-(void) onCacnel
{
  [delegate didCacnel];
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [UIApplication sharedApplication].statusBarHidden=YES;

  UIImage* image = [info valueForKey:UIImagePickerControllerOriginalImage];
  [self presentCropper:image];
   [picker dismissModalViewControllerAnimated:YES];
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{

  [self presentCropper:image];
  [picker dismissModalViewControllerAnimated:YES];
}

-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
  [picker dismissModalViewControllerAnimated:NO];
  [self onCacnel];
}



@end
