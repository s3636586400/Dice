//
//  MIDiceController.m
//  DicePhoto
//
//  Created by s3636586400 on 16/9/1.
//  Copyright © 2016年 MaskIsland. All rights reserved.
//

#import "MIDiceController.h"
#import "MIDicePhotoMaker.h"

@interface MIDiceController()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,DicePhotoMakerDelegate>

@property (nonatomic, strong) UIImageView *mainImageView;

@property (nonatomic, strong) UIImagePickerController *imagePicker;

@property (nonatomic, strong) UIActivityIndicatorView *indicator;

@property (nonatomic, strong) MIDicePhotoMaker *maker;

@end

@implementation MIDiceController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.barStyle    = UIBarStyleBlack;
    self.navigationController.navigationBar.translucent = NO;
}


- (void)initView {
    self.title = @"Dice Photo";
    [self createTextNavibar:@"相册" isLeft:YES];
    [self createTextNavibar:@"生成" isLeft:NO];
    self.view.backgroundColor = UIColorFromRGB(220, 220, 220);
    self.mainImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT_EXCEPTNAV)];
    _mainImageView.contentMode = UIViewContentModeScaleAspectFit;
    _mainImageView.image = [UIImage imageNamed:@"IMG_0707"];
    [self.view addSubview:_mainImageView];
    
    self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _indicator.center = _mainImageView.center;
}

#pragma mark -

- (void)createTextNavibar:(NSString *)text isLeft:(BOOL)isLeft {
    SEL action = isLeft ? @selector(leftItemAction) : @selector(rightItemAction);
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:text style:UIBarButtonItemStylePlain target:self action:action];
    NSDictionary *textAttribute = @{NSFontAttributeName : [UIFont systemFontOfSize:15.0]};
    [item setTitleTextAttributes:textAttribute forState:UIControlStateNormal];
    if (isLeft) {
        self.navigationItem.leftBarButtonItem = item;
    }else {
        self.navigationItem.rightBarButtonItem = item;
    }
}

- (void)leftItemAction {
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}

- (void)rightItemAction {
    //save
    if (self.navigationItem.rightBarButtonItem.tag) {
        UIImageWriteToSavedPhotosAlbum(_mainImageView.image, self, nil, NULL);
        self.navigationItem.rightBarButtonItem.title = @"生成";
        self.navigationItem.rightBarButtonItem.tag = !self.navigationItem.rightBarButtonItem.tag;
        return;
    }
    //trun to dice image
    if (!_maker) {
        self.maker = [[MIDicePhotoMaker alloc] init];
        self.maker.delegate = self;
    }
    [self.view addSubview:_indicator];
    [_indicator startAnimating];
    [_maker makeDiceImageFromImageView:self.mainImageView];
}

- (void)receiveDicePhotoImage:(UIImage *)diceImage {
    _mainImageView.image = diceImage;
    [_indicator stopAnimating];
    [_indicator removeFromSuperview];
    self.navigationItem.rightBarButtonItem.title = @"保存";
    self.navigationItem.rightBarButtonItem.tag = !self.navigationItem.rightBarButtonItem.tag;
}

#pragma mark -

- (UIImagePickerController *)imagePicker {
    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
        _imagePicker.navigationBar.barStyle    = UIBarStyleBlack;
        _imagePicker.navigationBar.translucent = NO;
    }
    return _imagePicker;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary<NSString *,id> *)editingInfo {
    _mainImageView.image = image;
    [_imagePicker dismissViewControllerAnimated:YES completion:nil];
    self.navigationItem.rightBarButtonItem.title = @"生成";
    self.navigationItem.rightBarButtonItem.tag = !self.navigationItem.rightBarButtonItem.tag;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
