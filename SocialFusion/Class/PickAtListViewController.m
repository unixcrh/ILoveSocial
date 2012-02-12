//
//  PickAtListViewController.m
//  SocialFusion
//
//  Created by Blue Bitch on 12-2-12.
//  Copyright (c) 2012年 TJU. All rights reserved.
//

#import "PickAtListViewController.h"
#import "UIButton+Addition.h"

#define kPlatformRenren NO
#define kPlatformWeibo  YES

@interface PickAtListViewController()
- (void)configureAtScreenNamesArray:(NSString*)text;
@end

@implementation PickAtListViewController

@synthesize delegate = _delegate;
@synthesize renrenButton = _renrenButton;
@synthesize weiboButton = _weiboButton;
@synthesize tableView = _tableView;
@synthesize textField = _textField;

- (void)dealloc {
    [_renrenButton release];
    [_weiboButton release];
    [_atScreenNames release];
    [_tableView release];
    [_textField release];
    _delegate = nil;
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.renrenButton = nil;
    self.weiboButton = nil;
    self.tableView = nil;
    self.textField = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.renrenButton setPostPlatformButtonSelected:YES];
    self.textField.text = @"";
    [self configureAtScreenNamesArray:self.textField.text];
    [self.tableView reloadData];
}

- (id)init {
    self = [super init];
    if(self) {
        _platformCode = kPlatformRenren;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
    }
    return self;
}

#pragma mark -
#pragma mark logic

- (void)configureAtScreenNamesArray:(NSString*)text
{    
    if (_atScreenNames) {
        [_atScreenNames removeAllObjects];
    }
    else {
        _atScreenNames = [[NSMutableArray alloc] init];
    }
    
    [_atScreenNames insertObject:[[[NSString alloc] initWithFormat:@"@%@", text] autorelease] atIndex:0];
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"WeiboUser" inManagedObjectContext:self.managedObjectContext];
    
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[[[NSString alloc] initWithFormat:@"name like[c] \"*%@*\"", text] autorelease]];
    
    [request setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    
    [request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    [sortDescriptor release];
    NSError *error;
    NSArray *array = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    for (int i = 0; i < [array count]; i++) {
        [_atScreenNames addObject:[[[NSString alloc] initWithFormat:@"@%@", [[array objectAtIndex:i] name]] autorelease]];
    }
}

#pragma mark -
#pragma makr IBAction

- (IBAction)didClickCancelButton:(id)sender {
    [self.delegate cancelPickUser];
}

- (IBAction)didClickFinishButton:(id)sender {
    NSString *result = [_atScreenNames objectAtIndex:0];
    [self.delegate didPickAtUser:result];
}

- (IBAction)didClickRenrenButton:(id)sender {
    _platformCode = kPlatformRenren;
    [self.renrenButton setPostPlatformButtonSelected:YES];
    [self.weiboButton setPostPlatformButtonSelected:NO];
}

- (IBAction)didClickWeiboButton:(id)sender {
    _platformCode = kPlatformWeibo;
    [self.renrenButton setPostPlatformButtonSelected:NO];
    [self.weiboButton setPostPlatformButtonSelected:YES];
}

- (IBAction)atTextFieldEditingChanged:(UITextField*)textField {
    //[self isAtStringValid:textField.text]
    if (YES) {
        [self configureAtScreenNamesArray:textField.text];
        [_tableView reloadData];
    }
    else {
        if (_atScreenNames) {
            [_atScreenNames removeAllObjects];
        }
        _atScreenNames = [[[NSMutableArray alloc] initWithObjects:[[[NSString alloc] initWithFormat:@"@%@", textField.text] autorelease], nil] autorelease];
        [_tableView reloadData];
    }
}

#pragma mark - 
#pragma mark UITableView data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_atScreenNames count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = @"PickAtTableViewCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] init] autorelease];
    }
    cell.textLabel.text = [_atScreenNames objectAtIndex:[indexPath row]];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
}

#pragma mark - 
#pragma mark UITableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath { 
    NSString *result = [_atScreenNames objectAtIndex:[indexPath row]];
    [self.delegate didPickAtUser:result];
}

#pragma mark -
#pragma mark Keyboard notification

- (void)keyboardWillShow:(NSNotification *)notification {
    
    NSDictionary *info = [notification userInfo];
    
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    //NSLog(@"keyboard changed, keyboard width = %f, height = %f", kbSize.width,kbSize.height);
    
    CGRect tableViewFrame = self.tableView.frame;
    tableViewFrame.size.height = self.view.frame.size.height - kbSize.height - tableViewFrame.origin.y;
    self.tableView.frame = tableViewFrame;
}

@end
