//
//  MLSettingsTableViewController.m
//  Monal
//
//  Created by Anurodh Pokharel on 12/26/17.
//  Copyright © 2017 Monal.im. All rights reserved.
//

#import "MLSettingsTableViewController.h"


NS_ENUM(NSInteger, kSettingSection)
{
    kSettingSectionApp=0,
    kSettingSectionSupport,
    kSettingSectionAbout,
    kSettingSectionCount
};

@interface MLSettingsTableViewController ()

@property (nonatomic, strong) NSArray *sections;
@property (nonatomic, strong) NSArray *appRows;
@property (nonatomic, strong) NSArray *supportRows;
@property (nonatomic, strong) NSArray *aboutRows;

@end

@implementation MLSettingsTableViewController 


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sections =@[@"App", @"Support", @"About"];
    
    self.appRows=@[@"Accounts", @"Notifications", @"Display", @"Cloud Storage"];
    self.supportRows=@[@"Email Support", @"Submit A Bug"];
    self.aboutRows=@[@"Rate Monal", @"Open Source", @"About", @"Version"];
    self.splitViewController.preferredDisplayMode=UISplitViewControllerDisplayModeAllVisible;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return kSettingSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSInteger toreturn=0;
    switch(section)
    {
        case kSettingSectionApp: {
           toreturn= self.appRows.count;
            break;
        }
        case kSettingSectionSupport: {
            toreturn=  self.supportRows.count;
            break;
        }
        case kSettingSectionAbout: {
            toreturn= self.aboutRows.count;
            break;
        }

    }
    
    return toreturn;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingsCell" forIndexPath:indexPath];
    
    switch(indexPath.section)
    {
        case kSettingSectionApp: {
            cell.textLabel.text= self.appRows[indexPath.row];
            break;
        }
        case kSettingSectionSupport: {
            cell.textLabel.text= self.supportRows[indexPath.row];
            break;
        }
        case kSettingSectionAbout: {
            if(indexPath.row==3)
            {
                NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
                NSString* version = [infoDict objectForKey:@"CFBundleShortVersionString"];
                NSString* build = [infoDict objectForKey:@"CFBundleVersion"];
               
                cell.textLabel.text= [NSString stringWithFormat:@"Version  %@ (%@)",version, build];
            } else {
                cell.textLabel.text= self.aboutRows[indexPath.row];
            }
            break;
        }
            
    }
    return cell;
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *toreturn;
    if(section!=kSettingSectionApp) toreturn= self.sections[section];
    return toreturn;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch(indexPath.section)
    {
        case kSettingSectionApp: {
           
            switch ((indexPath.row)) {
                case 0:
                    [self performSegueWithIdentifier:@"showAccounts" sender:self];
                    break;
                    
                case 1:
                    [self performSegueWithIdentifier:@"showNotification" sender:self];
                    break;
                    
                case 2:
                    [self performSegueWithIdentifier:@"showDisplay" sender:self];
                    break;
                    
                case 3:
                    [self performSegueWithIdentifier:@"showCloud" sender:self];
                    break;
                    
                default:
                    break;
            }
            
            break;
        }
        case kSettingSectionSupport: {
            switch ((indexPath.row)) {
                case 0:
                    [self composeMail];
                    break;
                    
                case 1:
                    //submit bug
                    break;
                default:
                    break;
            }
            break;
        }
        case kSettingSectionAbout: {
            switch ((indexPath.row)) {
                case 0:
                    [self openStoreProductViewControllerWithITunesItemIdentifier:317711500];
                    break;
                    
                case 1:
                    [self performSegueWithIdentifier:@"showOpenSource" sender:self];
                    break;
                    
                case 2:
                    [self performSegueWithIdentifier:@"showAbout" sender:self];
                    break;
               
                default:
                    break;
            }
            
            
            break;
        }
            
    }
}

- (void)openStoreProductViewControllerWithITunesItemIdentifier:(NSInteger)iTunesItemIdentifier {
    SKStoreProductViewController *storeViewController = [[SKStoreProductViewController alloc] init];
    
    storeViewController.delegate = self;
    
    NSNumber *identifier = [NSNumber numberWithInteger:iTunesItemIdentifier];
    
    NSDictionary *parameters = @{ SKStoreProductParameterITunesItemIdentifier:identifier, @"action":@"write-review"};
    
    [storeViewController loadProductWithParameters:parameters
                                   completionBlock:^(BOOL result, NSError *error) {
                                       if (result)
                                           [self presentViewController:storeViewController
                                                              animated:YES
                                                            completion:nil];
                                       else NSLog(@"SKStoreProductViewController: %@", error);
                                   }];
    
    
}

-(void)composeMail
{
    if([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController* composeVC = [[MFMailComposeViewController alloc] init];
        composeVC.mailComposeDelegate = self;
        [composeVC setToRecipients:@[@"info@monal.im"]];
        [self presentViewController:composeVC animated:YES completion:nil];
    }
    else  {
        UIAlertController *messageAlert =[UIAlertController alertControllerWithTitle:@"Error" message:@"There is no configured email account. Please email info@monal.im ." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *closeAction =[UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }];
        [messageAlert addAction:closeAction];
        
        [self presentViewController:messageAlert animated:YES completion:nil];
    }
    
}

#pragma mark - Message ui delegate
- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - SKStoreProductViewControllerDelegate

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    [viewController dismissViewControllerAnimated:YES completion:nil];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end