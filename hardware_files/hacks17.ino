#include <OneWire.h>

int temp_in=5; // define D05 as input pin connecting to DS18S20 S pin
OneWire ds(temp_in); 




int temp;
int sound_in = 12; // select the input pin for the potentiometer
int sound_led = 13; // select the pin for the LED
int sound_val ;  //  value from the digit input pin for sound
int vib_in=9;
int vib_led=8;
int vib_val;          //  value from the digit input pin for vibrations

void setup () {
  delay(3000);//Let system settle
  pinMode (sound_led, OUTPUT);
  pinMode (sound_in, INPUT);
  pinMode(vib_in,INPUT);
  pinMode(vib_led,OUTPUT);
  Serial.begin (9600);
}
void loop () {
 
  vib_val=digitalRead(vib_in);
  sound_val=digitalRead(sound_in);
  if (sound_val==LOW)
  {
    digitalWrite (sound_led, HIGH);
    //delay(50);
    }   
  else 
  {
    digitalWrite (sound_led, LOW);
    //delay(10);
    }
  if(vib_val==1)
  {
    digitalWrite(vib_led,HIGH);
   
   }
   else
     digitalWrite(vib_led,LOW);
  //Serial.println("temperature, sound, vibration");
  

   int HighByte, LowByte, TReading, SignBit, Tc_100, Whole, Fract;
  byte i;
  byte present = 0;
  byte data[12];
  byte addr[8];
 
  if ( !ds.search(addr)) {
      ds.reset_search();
      return;
  }
 
 
  ds.reset();
  ds.select(addr);
  ds.write(0x44,1); 
 
  //delay(1000);  
 
 
  present = ds.reset();
  ds.select(addr);    
  ds.write(0xBE);  
 
 
 
  for ( i = 0; i < 9; i++) { 
    data[i] = ds.read();
  }

  LowByte = data[0];
  HighByte = data[1];
  TReading = (HighByte << 8) + LowByte;
  SignBit = TReading & 0x8000;  
  if (SignBit)
  {
    TReading = (TReading ^ 0xffff) + 1;
  }
  Tc_100 = (6 * TReading) + TReading / 4; 
  Whole = Tc_100 / 100; 



  temp = Whole;

  Serial.print(temp);
  Serial.print(",");
  Serial.print(sound_val);
  Serial.print(",");
  Serial.println(vib_val);
  delay(75);



}

