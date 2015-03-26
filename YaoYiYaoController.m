//
//  YaoYiYaoController.m
//  haoshihui
//
//  Created by apple on 15-3-7.
//  Copyright (c) 2015年 NP. All rights reserved.
//
#define kFilteringFactor                0.1
#define kEraseAccelerationThreshold        2.0
#import "YaoYiYaoController.h"
#import "NPTheShopsNearController.h"
#import <AVFoundation/AVFoundation.h>

@interface YaoYiYaoController ()
@property CBCentralManager  *centralManager;
@property AVAudioPlayer *audioPlayer;
@end

@implementation YaoYiYaoController


- (void)dealloc
{
    [UIAccelerometer sharedAccelerometer].delegate = nil;
    //[super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [UIAccelerometer sharedAccelerometer].delegate = self;
    [UIAccelerometer sharedAccelerometer].updateInterval = 1.0f/40.0f;
   
    //蓝牙
    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:nil];
    
   // if (self.centralManager.state==CBPeripheralManagerStatePoweredOn) {
      //  [self.centralManager scanForPeripheralsWithServices:nil options:nil];
        
    //}
   //// else
    ////{
     //   NSLog(@"no");
   // }

    
    //修改nav返回键颜色
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:255.0/255 green:0 blue:171.0/255 alpha:1];
    // Do any additional setup after loading the view.
}

-(void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    
    if(central.state==CBCentralManagerStatePoweredOn)
    {
        NSLog(@"蓝牙设备开着");
        _canShake=YES;
    }
    else
    {
        NSLog(@"蓝牙设备关着");
        
        UIAlertView *alterView=[[UIAlertView alloc]initWithTitle:@"亲，请打开蓝牙哦" message:@"打开蓝牙摇一摇，优惠就会出现哦~" delegate:self cancelButtonTitle:@"好的。" otherButtonTitles: nil];
        [alterView show];
        _canShake=NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) viewWillAppear:(BOOL)animated
{
    
   
    _canShake=YES;

}
- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
    UIAccelerationValue  length, x, y, z;
    
    if (!_canShake)
    {
        return;
    }
    
    //Use a basic high-pass filter to remove the influence of the gravity
    myAccelerometer[0] = acceleration.x * kFilteringFactor + myAccelerometer[0] * (1.0 - kFilteringFactor);
    myAccelerometer[1] = acceleration.y * kFilteringFactor + myAccelerometer[1] * (1.0 - kFilteringFactor);
    myAccelerometer[2] = acceleration.z * kFilteringFactor + myAccelerometer[2] * (1.0 - kFilteringFactor);
    // Compute values for the three axes of the acceleromater
    x = acceleration.x - myAccelerometer[0];
    y = acceleration.y - myAccelerometer[0];
    z = acceleration.z - myAccelerometer[0];
    
    //Compute the intensity of the current acceleration
    length = sqrt(x * x + y * y + z * z);
    // If above a given threshold, play the erase sounds and erase the drawing view
    if(length >= kEraseAccelerationThreshold)
    {
        //是否响应摇一摇的标志
       
       
        [self playSound];
       
           _canShake = NO;
        [self performSelector:@selector(shakeEvent) withObject:nil afterDelay:1];
    }
}
-(void)playSound
{
    //1.音频文件的url路径
    NSURL *url=[[NSBundle mainBundle]URLForResource:@"yaoyiyao.mp3" withExtension:Nil];
    
    //2.创建播放器（注意：一个AVAudioPlayer只能播放一个url）
    self.audioPlayer=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:Nil];
    
    //3.缓冲
    [self.audioPlayer prepareToPlay];
    
    //4.播放
    [self.audioPlayer play];
}
-(void) shakeEvent
{
    
    //1.音频文件的url路径
    NSURL *url=[[NSBundle mainBundle]URLForResource:@"yaoyiyao.mp3" withExtension:Nil];
    
    //2.创建播放器（注意：一个AVAudioPlayer只能播放一个url）
    self.audioPlayer=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:Nil];
    
    //3.缓冲
    [self.audioPlayer prepareToPlay];
    
    //4.播放
    [self.audioPlayer play];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    NPTheShopsNearController *sec=[storyboard instantiateViewControllerWithIdentifier:@"TheShopsNear"];
    

    
    
    
    [self.navigationController pushViewController:sec animated:YES ];
}

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral{
    switch (peripheral.state) {
            //蓝牙开启且可用
        case CBPeripheralManagerStatePoweredOn:
        {
            NSLog(@"Bluetooth is currently powered on and available to use.");
            
        }
            break;
        default:
            NSLog(@"Peripheral Manager did change state");
            break;
    }
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
