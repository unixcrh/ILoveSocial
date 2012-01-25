//
//  LabelConverter.m
//  SocialFusion
//
//  Created by Blue Bitch on 12-1-22.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "LabelConverter.h"
#import "LNLabelViewController.h"

static LabelConverter *instance = nil;

@implementation LabelConverter

@synthesize configMap = _configMap;

- (void)dealloc {
    [_configMap release];
    [super dealloc];
}

+ (LabelConverter *)getInstance {
    if(instance == nil) {
        instance = [[LabelConverter alloc] init];
    }
    return instance;
}


- (void)configureLabelToContentMap {
    NSString *configFilePath = [[NSBundle mainBundle] pathForResource:@"LabelProperty-Config" ofType:@"plist"];  
    _configMap = [[NSDictionary alloc] initWithContentsOfFile:configFilePath]; 
}

- (id)init {
    self = [super init];
    if(self) {
        [self configureLabelToContentMap];
    }
    return self;
}

+ (NSArray *)getLabelsInfoWithLabelKeyArray:(NSArray *)labelKeyArray{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:labelKeyArray.count];
    for(NSString *labelKey in labelKeyArray) {
        LabelInfo *info = [LabelConverter getLabelInfoWithIdentifier:labelKey];
        [result addObject:info];
    }
    return result;
}

+ (NSArray *)getSystemDefaultLabelsIdentifier {
    LabelConverter *converter = [LabelConverter getInstance];
    return [converter.configMap objectForKey:kSystemDefaultLabels];
}

+ (NSArray *)getSystemDefaultLabelsInfo {
    NSArray *labelKeyArray = [LabelConverter getSystemDefaultLabelsIdentifier];
    return [self getLabelsInfoWithLabelKeyArray:labelKeyArray];
}

+ (NSArray *)getChildLabelsInfoWithParentLabelIndentifier:(NSString *)identifier andParentLabelName:(NSString *)name {
    LabelConverter *converter = [LabelConverter getInstance];
    NSMutableDictionary *parentLabelConfig = [NSMutableDictionary dictionaryWithDictionary:[converter.configMap objectForKey:identifier]];
    NSMutableArray *labelKeyArray = [NSMutableArray arrayWithObject:identifier];
    [labelKeyArray addObjectsFromArray:[parentLabelConfig objectForKey:kChildLabels]];
    NSArray *result = [self getLabelsInfoWithLabelKeyArray:labelKeyArray];
    LabelInfo *returnLabelInfo = [result objectAtIndex:0];
    returnLabelInfo.isReturnLabel = YES;
    if([identifier isEqualToString:kParentRenrenUser] || [identifier isEqualToString:kParentWeiboUser]) {
        returnLabelInfo.labelName = name;
    }
    return result;
}

+ (NSString *)getDefaultChildIdentifierWithParentIdentifier:(NSString *)identifier {
    LabelConverter *converter = [LabelConverter getInstance];
    NSDictionary *parentLabelConfig = [converter.configMap objectForKey:identifier];
    NSArray *childLabels = [parentLabelConfig objectForKey:kChildLabels];
    return [childLabels objectAtIndex:0];
}

+ (LabelInfo *)getLabelInfoWithIdentifier:(NSString *)identifier {
    LabelConverter *converter = [LabelConverter getInstance];
    NSDictionary *labelConfig = [converter.configMap objectForKey:identifier];
    NSString *labelName = [labelConfig objectForKey:kLabelName];
    NSNumber *isRetractable = [labelConfig objectForKey:kLabelIsRetractable];
    LabelInfo *info = [LabelInfo labelInfoWithIdentifier:identifier labelName:labelName isRetractable:isRetractable.boolValue];
    return info;
}

@end
