//
//  BeautifiedPictureViewController.h
//  TheMusicCamera
//
//  Created by gzhy on 13-12-13.
//  Copyright (c) 2013年 songl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CropperController.h"
#import "StampView.h"

@class DataManager;
//@class StampView;

@interface BeautifiedPictureViewController : UIViewController<UINavigationControllerDelegate, CropControllerDelegate,StampViewDelegate>
{
    IBOutlet UIImageView* imageView;
    IBOutlet UIView *mianView;
    
    DataManager *dataManager;

    int selectBtnTag;
    StampView *stampView;
    StampView *stampFrameView;

    NSMutableArray *stampArr;
    NSMutableArray *stampFrameArr;

}

-(void) begin;
@end
