//
//  DataManager.m
//  TheMusicCamera
//
//  Created by gzhy on 13-12-13.
//  Copyright (c) 2013年 songl. All rights reserved.
//

#import "DataManager.h"
#import "DBAccress.h"

@implementation DataManager



-(id) init{
	self = [super init];
	
	if (self){

        _databaseName = @"music.sqlite";
        _path = [[NSBundle mainBundle] resourcePath];
        _downloadPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        [self checkAndCreateDatabase];
        [self createDirectory:@"music"];

    }
	return self;
}

-(void) createDirectory:(NSString *)dir
{
	NSString *folderPath = [_downloadPath stringByAppendingPathComponent:dir];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	BOOL fileExists = [fileManager fileExistsAtPath:folderPath];
	
	if (!fileExists) {
		[fileManager createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
	}
}

-(void) checkAndCreateDatabase
{
	_databasePath = [_downloadPath stringByAppendingPathComponent:_databaseName];
    
	BOOL success;
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	success = [fileManager fileExistsAtPath:_databasePath];
    
	if(success)
        return;
    
	NSString *databasePathFromApp = [_path stringByAppendingPathComponent:_databaseName];
	[fileManager copyItemAtPath:databasePathFromApp toPath:_databasePath error:nil];
}

- (int)getMusicId//
{
    DBAccress *dBAccress=[[DBAccress alloc] init];
    return [dBAccress getMusicId];
}

//////////////////////////////////////////////////////////////////////////
static DataManager *sharedDataManager = nil;

+ (DataManager *) sharedManager
{
    @synchronized(self)
	{
        if (sharedDataManager == nil)
		{
            return [[self alloc] init];
        }
    }
	
    return sharedDataManager;
}

+(id)alloc
{
	@synchronized(self)
	{
		NSAssert(sharedDataManager == nil, @"Attempted to allocate a second instance of a singleton.");
		sharedDataManager = [super alloc];
		return sharedDataManager;
	}
	return nil;
}


@end

@implementation UIViewController (UIViewControllerCategory)


- (void)navgationImage:(NSString *)imageName
{
    self.navigationController.navigationBarHidden = YES;
    
    UIImageView *headImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 49)];
    headImage.image = [UIImage imageNamed:imageName];
    [self.view addSubview:headImage];
}

- (UIButton *)navgationButton:(NSString *)buttonImage andFrame:(CGRect)rect
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = rect;
    [button setBackgroundImage:[UIImage imageNamed:buttonImage] forState:UIControlStateNormal];
    [self.view addSubview:button];
    return button;
}

- (void)back {
	[self.navigationController popViewControllerAnimated:YES];
}


@end

