//
//  AppCollectionViewCell.h
//  OneThingWell
//
//  Created by Lanston Peng on 9/29/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OneThingModel.h"

@interface AppCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *appTitle;
@property (weak, nonatomic) IBOutlet UIButton *favButton;
@property (weak, nonatomic) IBOutlet UILabel *pubTimeLabel;

@property (strong,nonatomic)UITextView* appDescriptionTextView;

@property (strong,nonatomic)OneThingModel* cellDataModel;

- (void)configureCellUI;

- (void)configureCellData;
@end
