//
//  ViewController.m
//  DemoApp
//
//  Created by Ravikiran Gajula on 16/02/2020.
//  Copyright © 2020 Ravikiran Gajula. All rights reserved.
//

#import "ViewController.h"
#import <MovieSDK/MovMain.h>
#import "MenuTableViewCell.h"
#import "NSString+AESCrypt.h"


@interface ViewController () <UITableViewDelegate, UITableViewDataSource>{
    UIActivityIndicatorView * spinner;
    NSMutableArray * movieList;
    //KeychainItemWrapper *keychainInstance;
}
@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (weak, nonatomic) IBOutlet UITextField *apiKeyField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /// Step1 : InitSDK with APIkey
    /// if APIKey not passed here then developer should call setApiKey method
    [MovMain initSDK:@"5540e684dd562fd2be412b9aeda753c0"];
    _apiKeyField.text = @"5540e684dd562fd2be412b9aeda753c0";
   // keychainInstance = [[KeychainItemWrapper alloc] initWithIdentifier:@"ApiKey" accessGroup:nil];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MenuTableViewCell" bundle:nil] forCellReuseIdentifier:@"menuCell"];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    movieList  = [[NSMutableArray alloc]init];
    
}

- (NSString*)getEncryptionKey {
    return [[NSBundle mainBundle] bundlePath];
}

- (IBAction)tapOnSearch:(id)sender {
   
    [self resignTextFields];
    
    /// Check if apikey field was empty . if empty check if already api key was saved . if saved retrive friom defaults else return and show message to input key
    if ([_apiKeyField.text length] <= 0) {
        NSLog(@"Error: Input proper API Key");
        return;
    } else {
        if ([self getSavedAPiKey] != nil) {
            ///Step2: if APIkey was not set in initSDK then used should set here before calling getMovieResults API
            [MovMain setApiKey:[self getSavedAPiKey]];
        } else {
            [self saveKeyToDefaults:_apiKeyField.text];
            [MovMain setApiKey:[self getSavedAPiKey]];
        }
    }

    if ([_searchField.text length] <= 0) {
        NSLog(@"Error: Search query is nil");
        return;
    }
    
    [movieList removeAllObjects];
    [self setSpinner];

    ///Step3: Call this API for searched results. its Mandatory to set API key before this method
    [MovMain getMovieResults:_searchField.text callBackWithResult:^(NSArray * _Nonnull array, NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [spinner stopAnimating];
            movieList = [array mutableCopy];
            NSLog(@"SDK result %@",array);
            [_tableView reloadData];
        });
    }];
}

/// APP KeyChain is more secure than USerDefauts. Consudering this as assignment i used UserDefaults.
-(void)saveKeyToDefaults:(NSString*)apiKey {
    
    NSString *encrypted = [apiKey AES256EncryptWithKey:[self getEncryptionKey]];
    [[NSUserDefaults standardUserDefaults] setValue:encrypted forKey:@"apiKey"];
    
}

-(NSString*)getSavedAPiKey {
    NSString * str = [[NSUserDefaults standardUserDefaults]valueForKey:@"apiKey"];
    NSString *decrypted = [str AES256DecryptWithKey:[self getEncryptionKey]];
    return decrypted;
    
}

-(void)resignTextFields {
    [_searchField resignFirstResponder ];
    [_apiKeyField resignFirstResponder];
}

-(void)setSpinner {
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];
    spinner.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    spinner.tag = 12;
    [self.view addSubview:spinner];
    [spinner startAnimating];
}


#pragma TableView Methods

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MenuTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"menuCell" forIndexPath:indexPath];
    NSDictionary * dict = movieList[indexPath.row];
    NSString * title = [dict valueForKey:@"title"];
    NSString * yearReleased = [dict valueForKey:@"release_date"];
    NSString * rating = [dict valueForKey:@"vote_average"];
    NSString * image  = [NSString stringWithFormat:@"https://image.tmdb.org/t/p/w500/%@",[dict valueForKey:@"poster_path"]];

    NSString * final = [NSString stringWithFormat:@"Title : %@ \n Date : %@ \n Ratting: %@", title, yearReleased, rating];
    ///poster_path
    cell.labelDetail.text = final;
    
    NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:image]];
     cell.iconImage.image = [UIImage imageWithData: imageData];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return movieList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

@end
