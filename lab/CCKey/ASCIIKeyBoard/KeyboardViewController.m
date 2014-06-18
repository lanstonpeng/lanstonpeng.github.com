//
//  KeyboardViewController.m
//  ASCIIKeyBoard
//
//  Created by Lanston Peng on 6/16/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "KeyboardViewController.h"
#import "SmoothLineView.h"
#import "UIImage+ASCII.h"

@interface KeyboardViewController ()<SmoothLineDelegate>
@property (nonatomic, strong) UIButton *nextKeyboardButton;
@property (strong,nonatomic) SmoothLineView * smoothLineView;
@end

@implementation KeyboardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Perform custom initialization work here
    }
    return self;
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    // Add custom view sizing constraints here
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Perform custom UI setup here

    self.nextKeyboardButton = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [self.nextKeyboardButton setTitle:NSLocalizedString(@"Click", @"Title for 'Next Keyboard' button") forState:UIControlStateNormal];
    [self.nextKeyboardButton sizeToFit];
    self.nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.nextKeyboardButton addTarget:self action:@selector(advanceToNextInputMode) forControlEvents:UIControlEventTouchUpInside];
    //[self.nextKeyboardButton addTarget:self action:@selector(insertSomething) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.nextKeyboardButton];
    _smoothLineView =[[SmoothLineView alloc] initWithFrame:CGRectMake(0, 0, 320 , 200)];
    _smoothLineView.backgroundColor = [UIColor yellowColor];
    _smoothLineView.delegate = self;
    
    UIButton* generate = [[UIButton alloc]initWithFrame:CGRectMake(280, 0, 40, 40)];
    generate.backgroundColor = [UIColor orangeColor];
    [generate setTitle:@"Go" forState:UIControlStateNormal];
    [generate addTarget:self action:@selector(generateASCII:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_smoothLineView];
    [self.view addSubview:generate];
    
    
    NSLayoutConstraint *nextKeyboardButtonLeftSideConstraint = [NSLayoutConstraint constraintWithItem:self.nextKeyboardButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0];
    NSLayoutConstraint *nextKeyboardButtonBottomConstraint = [NSLayoutConstraint constraintWithItem:self.nextKeyboardButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
    [self.view addConstraints:@[nextKeyboardButtonLeftSideConstraint, nextKeyboardButtonBottomConstraint]];
    
     }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated
}

- (void)textWillChange:(id<UITextInput>)textInput {
    // The app is about to change the document's contents. Perform any preparation here.
}

- (void)textDidChange:(id<UITextInput>)textInput {
    // The app has just changed the document's contents, the document context has been updated.
    
    UIColor *textColor = nil;
    if (self.textDocumentProxy.keyboardAppearance == UIKeyboardAppearanceDark) {
        textColor = [UIColor whiteColor];
    } else {
        textColor = [UIColor blackColor];
    }
    [self.nextKeyboardButton setTitleColor:textColor forState:UIControlStateNormal];
}
-(void)insertSomething
{
    [self.textDocumentProxy insertText:@"what"];
}

-(void)cropKeyBoardScreen
{
    CGRect rects = [[UIScreen mainScreen] bounds];
    
    UIGraphicsBeginImageContextWithOptions(rects.size, NO, [UIScreen mainScreen].scale);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    CGFloat scale = [UIScreen mainScreen].scale;
    CGRect rect = _smoothLineView.frame;
    CGRect  newRect = CGRectMake(rect.origin.x* scale,
                                 rect.origin.y* scale,
                                 rect.size.width* scale,
                                 rect.size.height*scale);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([img CGImage], newRect);
    UIImage *result = [UIImage imageWithCGImage:imageRef scale:scale orientation:UIImageOrientationUp];
    CGImageRelease(imageRef);
    UIGraphicsEndImageContext();
    
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    NSData * binaryImageData = UIImagePNGRepresentation(result);
    //[binaryImageData writeToFile:[basePath stringByAppendingPathComponent:@"myfile.png"] atomically:YES];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    paragraphStyle.lineHeightMultiple = 6.0f;
    paragraphStyle.maximumLineHeight = 6.0f;
    paragraphStyle.minimumLineHeight = 6.0f;
    
    NSString *string = result.asciiText;
    
    NSString *precedingContext = self.textDocumentProxy.documentContextBeforeInput;
    /*for(int k = 0 ;k < precedingContext.length;k++)
    {
        [self.textDocumentProxy deleteBackward];
    }*/
    [self.textDocumentProxy insertText:string];
    /*
    NSDictionary *ats = @{
                          NSFontAttributeName : [UIFont systemFontOfSize:14.0f],
                          NSParagraphStyleAttributeName : paragraphStyle,
                          };
    */
    //_tv.attributedText = [[NSAttributedString alloc] initWithString:string attributes:ats];
}

- (void)strokeEnd:(CGPoint)endPoint
{
    
}
-(void)generateASCII:(id)sender
{
    [self cropKeyBoardScreen];
    [_smoothLineView clear];
}
@end
