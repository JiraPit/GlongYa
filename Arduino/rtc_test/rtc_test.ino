#include <Wire.h> // must be included here so that Arduino library object file references work
#include <RtcDS3231.h>
RtcDS3231<TwoWire> Rtc(Wire);

uint8_t month, day, hour, minute, second;
uint16_t year;

void setup () 
{
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
  RtcDateTime now = Rtc.GetDateTime();
  printDateTime(now);
}