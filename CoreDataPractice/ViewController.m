//
//  ViewController.m
//  CoreDataPractice
//
//  Created by Saad Mahmood on 5/24/16.
//  Copyright © 2016 Saad Mahmood. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)addName:(id)sender;

@property(strong, nonatomic) NSMutableArray * people;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    self.tableView.delegate = self;
    self.people = [NSMutableArray new];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    AppDelegate * appDelegate =
    (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext * managedContext = [appDelegate managedObjectContext];
    
    NSFetchRequest * fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Person"];
    
    NSError * error = [NSError errorWithDomain:@"Could not fetch data" code:1 userInfo:nil];
    NSArray * results = [managedContext executeFetchRequest:fetchRequest error:&error];
    self.people = [results mutableCopy];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)addName:(id)sender {
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"New Name" message:@"Add a New Name" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * saveAction = [UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField * textField = [[alert textFields]firstObject];
        [self saveName:[textField text]];
        [self.tableView reloadData];
    }];
    
    
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
    }];
    
    [alert addAction:saveAction];
    [alert addAction:cancelAction];
    
    [alert.view setNeedsLayout];
    [self presentViewController:alert animated:YES completion:nil];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.people count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    NSManagedObject * person = [self.people objectAtIndex:indexPath.row];
    cell.textLabel.text = [person valueForKey:@"name"];
    
    return cell;
}

-(void)saveName:(NSString *)name {
    AppDelegate * appDelegate =
    (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    NSManagedObjectContext * managedContext = [appDelegate managedObjectContext];
    
    NSEntityDescription* entity =  [NSEntityDescription entityForName:@"Person" inManagedObjectContext:managedContext];
    
    NSManagedObject * person = [[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:managedContext];
    
    [person setValue:name forKey: @"name"];
    NSError * error = [NSError errorWithDomain:@"Could not save data" code:1 userInfo:nil];
    [managedContext save:&error];
    [self.people addObject: person];
}

@end
