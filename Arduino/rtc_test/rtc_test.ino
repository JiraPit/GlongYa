#include <ThreeWire.h>  
#include <RtcDS1302.h>
z
ThreeWire myWire(A4, A5, 10); // IO, SCLK, CE
RtcDS1302<ThreeWire> Rtc(myWire);

uint8_t month, day, hour, minute, second;
uint16_t year;

void setup () 
{
    Serial.begin(57600);
    
/*********************** RTC Setting *********************/
    Rtc.Begin();

    RtcDateTime compiled = RtcDateTime(__DATE__, __TIME__);

    RtcDateTime now = Rtc.GetDateTime();
    if (now < compiled) Rtc.SetDateTime(compiled);
/*********************************************************/
}

void loop () 
{
  /**********************************/
  RtcDateTime now = Rtc.GetDateTime();
  printDateTime(now);
  /**********************************/
}

void printDateTime(const RtcDateTime& dt)
{
  year   = (int)dt.Year();
  month  = (int)dt.Month();
  day    = (int)dt.Day();
  hour   = (int)dt.Hour();
  minute = (int)dt.Minute();
  second = (int)dt.Second();
  
  String str = String(day) + 
               "/" + String(month) + 
               "/" + String(year) + 
               "   " + String(hour) + 
               ":" + String(minute) + 
               ":" + String(second);
  Serial.println(str);
}