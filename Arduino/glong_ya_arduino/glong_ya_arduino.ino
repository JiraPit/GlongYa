#include <Wire.h> // must be included here so that Arduino library object file references work
#include <RtcDS3231.h>
#include <SoftwareSerial.h>

RtcDS3231<TwoWire> Rtc(Wire);
SoftwareSerial bluetooth(2,3);

uint8_t hour, minute, second;
int buzzerPin = 5;
int alarm[3][2] = {{21,44},{21,34},{21,34}};

void setup () 
{
    start_buzzer();
    Serial.begin(57600);
/*********************** RTC Setup *********************/
    Rtc.Begin();
    RtcDateTime compiled = RtcDateTime(__DATE__, __TIME__);
    RtcDateTime now = Rtc.GetDateTime();
    if (now < compiled) Rtc.SetDateTime(compiled);
    Rtc.Enable32kHzPin(false);
    Rtc.SetSquareWavePin(DS3231SquareWavePin_ModeNone);
/*********************************************************/
}

void loop () 
{
  if (Serial.available()>0){
    String rec = Serial.readStringUntil('!');
    if (rec != "!"){
      Serial.println(rec);
      String box[4];
      char sz[128];
      rec.toCharArray(sz,sizeof(sz));
      char *str,*p = sz;
      int index = 0;
      while(str = strtok(p,"/")) {
        box[index] = str;
        p = NULL;
        ++index;        
      }
      alarm[0][0] = box[0].substring(0,box[0].indexOf(",")).toInt();
      alarm[0][1] = box[0].substring(box[0].indexOf(",")+1).toInt();
      alarm[1][0] = box[1].substring(0,box[1].indexOf(",")).toInt();
      alarm[1][1] = box[1].substring(box[1].indexOf(",")+1).toInt();
      alarm[2][0] = box[2].substring(0,box[2].indexOf(",")).toInt();
      alarm[2][1] = box[2].substring(box[2].indexOf(",")+1).toInt();
      
    }
  }
  RtcDateTime now = Rtc.GetDateTime();
  for (int i = 0; i< 3; i++){
    if ((int)now.Hour() == alarm[i][0] && (int)now.Minute() == alarm[i][1] && (int)now.Second() == 0) {
    alarm_buzzer();
    delay(2000);
    }
  }
  
}

void start_buzzer(){
  tone(buzzerPin,2000);
  delay(200);
  noTone(buzzerPin);
  delay(100);
  tone(buzzerPin,2000);
  delay(200);
  noTone(buzzerPin);
}

void alarm_buzzer(){
    for(int i = 0; i < 15; i ++){
      tone(buzzerPin,2000);
      delay(100);
      noTone(buzzerPin);
      delay(100);
    }

}

