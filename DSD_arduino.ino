//connect SDA of LCD to A4!!!!
//connect SCL of LCD to A5!!!!

#include <Wire.h>
#include <LiquidCrystal_I2C.h>
LiquidCrystal_I2C lcd (0x27, 16, 2); 
int buzzer = 3;
int but = 4;
int moving = 2;
int pl = 10;

int lvl0 = A0;
int lvl1 = A1;
int lvl2 = A2;

#define REC 6 // pin 2 is used for recording
#define PLAY_E 7 // pin 3 is used for playback-edge trigger
#define FT 5 // pin 5 is used for feed through

#define playTime 5000 // playback time 5 seconds
#define recordTime 3000 // recording time 3 seconds you can extend time upto 10 seconds

void setup() {
  
  pinMode(but, INPUT);
  pinMode(moving, INPUT);
  pinMode(buzzer, OUTPUT);
  pinMode(pl, INPUT);
  
  pinMode(lvl0, INPUT);
  pinMode(lvl1, INPUT);
  pinMode(lvl2, INPUT);

  pinMode(REC,OUTPUT);// set the REC pin as output
  pinMode(PLAY_E,OUTPUT);// set the PLAY_e pin as output
  pinMode(FT,OUTPUT);// set the FT pin as output  
  
  Serial.begin(9600);
  Serial.println("Check");
  
  lcd.init(); 
  lcd.backlight();
  lcd.clear();
  lcd.setCursor(4, 0);
  lcd.print("Ground");
  lcd.setCursor(7, 1);
  lcd.print("floor");
}

void loop() {
  // put your main code here, to run repeatedly:

  Serial.println("Herre");
  if (digitalRead(lvl0))// and (prevState != 0))
  {
    Serial.println("lvl0");
    lcdprint(0);
   
  }
  else if (digitalRead(lvl1))// and (prevState != 1))
  {
    Serial.println("lvl1");
    lcdprint(1);
    
  }
  else if (digitalRead(lvl2))// and (prevState != 2))
  {
    Serial.println("lvl2");
    lcdprint(2);
   
  }

  if (digitalRead(but))
  {
    Serial.println("buzzer");
    buzz();
  }

  playy();
  
}


  void buzz()
{
  for (int i = 0; i<3; i++)
  {
  digitalWrite(buzzer, HIGH);
  delay (125);
  digitalWrite(buzzer, LOW);
  delay (125);
  }
}

void lcdprint (int i)
{
  Serial.println("lcd");
  lcd.clear();
  lcd.setCursor(4, 0);
  switch(i)
  {
    case 0: lcd.print("Ground"); break;
    case 1: lcd.print("First"); break;
    case 2: lcd.print("Second"); break;
  }
  lcd.setCursor(7, 1);
  lcd.print("floor");
}



void playy()
{
  while (digitalRead(moving)==LOW) {
         
           if(digitalRead(moving)==LOW){
           digitalWrite(PLAY_E, HIGH);
//           digitalWrite(ledp, HIGH);
           delay(50);
           digitalWrite(PLAY_E, LOW);  
             Serial.println("Playbak Started");  
           delay(playTime);
             Serial.println("Playbak Ended");
//              digitalWrite(ledp, LOW);
           break; 
           }
  delay(50);
}
}
