/*****************************************************
Chip type               : ATmega64A
Program type            : Application
AVR Core Clock frequency: 16,000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 1024
*****************************************************/

#include <mega64a.h>
#include <delay.h>
#include <spi.h>

//-----------------------------------------------------------------------
#define KA1_ON          (PINA.6==0)//�������� �������� �������� 5.23
#define KA1_OFF         (PINA.6==1)
#define KA2_ON          (PINA.7==0)//�������� ������ 8.6
#define KA2_OFF         (PINA.7==1)
#define KA3_ON          (PINA.4==0)//���������� �������� 8.13
#define KA3_OFF         (PINA.4==1)
#define KA4_ON          (PINA.5==0)//���������� ����� 8.20
#define KA4_OFF         (PINA.5==1)
#define KA551_ON        (PINA.2==0)//�������� ������� ������,�������� ������������� 9.11
#define KA551_OFF       (PINA.2==1)
#define KA6_ON          (PINF.2==0)//����������� � 9.17
#define KA6_OFF         (PINF.2==1)
#define KA7_ON          (PINF.3==0)//����������� Z 9.19
#define KA7_OFF         (PINF.3==1)
#define KA8_ON          (PINC.4==0)//�������� ������ 10.19
#define KA8_OFF         (PINC.4==1)
#define KA9_ON          (PINC.3==0)//�������� ���������� ������ 11.22
#define KA9_OFF         (PINC.3==1)
#define KA11_ON         (PINF.4==0)//�������� ������� 16.10
#define KA11_OFF        (PINF.4==1)

#define SQ7_ON          (PINF.5==0)//T1
#define SQ7_OFF         (PINF.5==1)//T1
#define SQ8_ON          (PINF.6==0)//T2
#define SQ8_OFF         (PINF.6==1)//T2
#define SQ9_ON          (PINF.7==0)//T3
#define SQ9_OFF         (PINF.7==1)//T3
#define SQ10_ON         (PINA.0==0)//T4
#define SQ10_OFF        (PINA.0==1)//T4
#define K1_ON           (PINC.7==0)//Current
#define K1_OFF          (PINC.7==1)

#define KA13_ON         (PINC.2==0)//�������� �������� ������� 18.3
#define KA13_OFF        (PINC.2==1)

#define KA22_ON         (PIND.0==0)//1
#define KA22_OFF        (PIND.0==1)
#define KA23_ON         (PIND.1==0)//2
#define KA23_OFF        (PIND.1==1)
#define KA24_ON         (PIND.2==0)//4
#define KA24_OFF        (PIND.2==1)
#define KA25_ON         (PIND.3==0)//8
#define KA25_OFF        (PIND.3==1)
#define KA26_ON         (PIND.4==0)//40
#define KA26_OFF        (PIND.4==1)
#define KA27_ON         (PIND.5==0)//M
#define KA27_OFF        (PIND.5==1)
#define KA29_ON         (PIND.6==0)//T
#define KA29_OFF        (PIND.6==1)
#define KA30_ON         (PIND.7==0)//������� �����
#define KA30_OFF        (PIND.7==1)
#define KA31_ON         (PINF.1==0)//������ �����
#define KA31_OFF        (PINF.1==1)
#define KA32_ON         (PINF.0==0)//���������� ������
#define KA32_OFF        (PINF.0==1)
#define KA33_ON         (PINE.2==0)//����������
#define KA33_OFF        (PINE.2==1)
#define KA34_ON         (PINE.3==0)//CNC normal 23.15
#define KA34_OFF        (PINE.3==1)
#define KA54_ON         (PINC.1==0)//S 0
#define KA54_OFF        (PINC.1==1)
#define KA55_ON         (PINC.0==0)//S 1
#define KA55_OFF        (PINC.0==1)
#define KA56_ON         (PINC.5==0)//S 2
#define KA56_OFF        (PINC.5==1)
//------------------------------------------------------
#define KAR47_ON         XS6|=(1<<0);//ON S
#define KAR47_OFF        XS6&=~(1<<0);
#define KAR100_ON        XS6|=(1<<1);//ON X,Z
#define KAR100_OFF       XS6&=~(1<<1);
#define KAR30_ON         XS6|=(1<<2);//AUTO
#define KAR30_OFF        XS6&=~(1<<2);
#define KAR32_ON         XS7|=(1<<0);//ON Oil
#define KAR32_OFF        XS7&=~(1<<0);
#define KAR45_ON         XS6|=(1<<3);//ON Cool_1
#define KAR45_OFF        XS6&=~(1<<3);
#define KAR46_ON         XS6|=(1<<4);//ON Cool_2
#define KAR46_OFF        XS6&=~(1<<4);
#define KAR12_ON         XS7|=(1<<1);//CW_T
#define KAR12_OFF        XS7&=~(1<<1);//CCW_T
#define KAR10_ON         XS7|=(1<<2);//ON T
#define KAR10_OFF        XS7&=~(1<<2);//OFF T
#define KAR13_ON         XS7|=(1<<3);
#define KAR13_OFF        XS7&=~(1<<3);
#define KAR103_ON        XS7|=(1<<4);//S 1
#define KAR103_OFF       XS7&=~(1<<4);
#define KAR104_ON        XS7|=(1<<5);//S 2
#define KAR104_OFF       XS7&=~(1<<5);
#define KAR105_ON        XS7|=(1<<6);//S 0
#define KAR105_OFF       XS7&=~(1<<6);
#define KAR107_ON        XS6|=(1<<5);//ON RVK
#define KAR107_OFF       XS6&=~(1<<5);
#define KAR34_ON         XS6|=(1<<6);//Ready turn
#define KAR34_OFF        XS6&=~(1<<6);
//------------------------------------------------------
#define HL8_ON           XS8|=(1<<0);
#define HL8_OFF          XS8&=~(1<<0);
#define HL7_ON           XS8|=(1<<1);
#define HL7_OFF          XS8&=~(1<<1);
#define HL6_ON           XS8|=(1<<2);
#define HL6_OFF          XS8&=~(1<<2);
#define HL5_ON           XS8|=(1<<3);
#define HL5_OFF          XS8&=~(1<<3);
#define HL4_ON           XS8|=(1<<4);
#define HL4_OFF          XS8&=~(1<<4);
#define HL3_ON           XS8|=(1<<5);
#define HL3_OFF          XS8&=~(1<<5);
#define HL2_ON           XS8|=(1<<6);
#define HL2_OFF          XS8&=~(1<<6);
#define HL1_ON           XS8|=(1<<7);
#define HL1_OFF          XS8&=~(1<<7);
//------------------------------------------------------
int time=0;
unsigned char XS6=0,XS7=0,XS8=0,XS9=0;
//------------------------------------------------------
void init(void);//Initialization of the entire periphery
interrupt [TIM3_OVF] void timer3_ovf_isr(void);//lubrication
interrupt [TIM1_OVF] void timer1_ovf_isr(void);//counting time
void timer_on(void);//enable timer 1 (counting time)
void timer_off(void);//disable timer 1 (counting time)
void out(unsigned char xs_6, unsigned char xs_7, unsigned char xs_8, unsigned char xs_9);//set outputs
void led(void);//enable/disable leds
void m_t(char enable);//processing M,T-commands
char scan(void);//input processing
//------------------------------------------------------
//
//------------------------------------------------------
void main(void)
{
    init();
    out(XS6,XS7,XS8,XS9);
    KAR12_ON
    KAR10_ON
    out(XS6,XS7,XS8,XS9);
    delay_ms(100);
    KAR10_OFF
    KAR12_OFF
    out(XS6,XS7,XS8,XS9);

while (1)
      { 
        m_t(scan());
        led();      
        out(XS6,XS7,XS8,XS9);        
      }
}
//------------------------------------------------------
//
//------------------------------------------------------
void m_t(char enable)
{
    int ka22 = 0;
    int ka23 = 0;
    int ka24 = 0;
    int ka25 = 0;
    int ka26 = 0;
    static int M=0;
    static int T=0;
    static int KOD=0;

    if(KA22_ON){ka22=1;}else{ka22=0;}//1     
    
    if(KA23_ON){ka23=1;}else{ka23=0;}//2
    
    if(KA24_ON){ka24=1;}else{ka24=0;}//4
    
    if(KA25_ON){ka25=1;}else{ka25=0;}//8
    
    if(KA26_ON){ka26=1;}else{ka26=0;}//40
    
    KOD = ka22 + 2*ka23 + 4*ka24 + 8*ka25 + 40*ka26;
    
    if(KA33_ON){
        if(KA27_ON)M = KOD;
        if(KA29_ON)T = KOD;
    }
                            
    if(KA8_ON && M!=6 && KA9_ON && KA11_ON && !KA27_ON && !KA29_ON){KAR107_ON}else{KAR107_OFF}//RVK
    
    switch(M){
        case 3:     if(enable)
                        KAR47_ON//ON S
                    M = 0;
                    break;
                    
        case 4:     if(enable)
                        KAR47_ON//ON S
                    M = 0;
                    break;
                    
        case 5:     KAR47_OFF//OFF S
                    M = 0;
                    break;
                    
        case 6:     KAR10_ON
                    out(XS6,XS7,XS8,XS9);
                    timer_on();
                    if(T==1){
                      while(SQ7_OFF && time<20){
                        if(KA11_ON){HL4_ON}else{HL4_OFF}
                        out(XS6,XS7,XS8,XS9);
                      }
                    }
                    if(T==2){
                      while(SQ8_OFF && time<20){
                        if(KA11_ON){HL4_ON}else{HL4_OFF}
                        out(XS6,XS7,XS8,XS9);
                      }                    
                    }
                    if(T==3){
                      while(SQ9_OFF && time<20){
                        if(KA11_ON){HL4_ON}else{HL4_OFF}
                        out(XS6,XS7,XS8,XS9);
                      }                   
                    }
                    if(T==4){
                      while(SQ10_OFF && time<20){
                        if(KA11_ON){HL4_ON}else{HL4_OFF}
                        out(XS6,XS7,XS8,XS9);
                      }                    
                    }
                    
                    if(time<20){
                        timer_off();
                        KAR12_ON
                        out(XS6,XS7,XS8,XS9);
                        timer_on();
                        while((K1_OFF | KA11_OFF) && time<20){
                            if(KA11_ON){HL4_ON}else{HL4_OFF}
                            out(XS6,XS7,XS8,XS9);
                        }
                        KAR10_OFF
                        KAR12_OFF
                        out(XS6,XS7,XS8,XS9);
                        timer_off();
                    }
                    
                    KAR10_OFF
                    KAR12_OFF
                    out(XS6,XS7,XS8,XS9);    
                    timer_off();
                    M = 0;
                    break;
                    
        case 7:     KAR45_ON
                    M = 0;
                    break;
                                   
        case 8:     KAR46_ON
                    M = 0;
                    break;
                    
        case 9:     KAR46_OFF
                    KAR45_OFF
                    M = 0;
                    break;
                    
        case 40:    KAR105_ON 
                    KAR47_ON
                    out(XS6,XS7,XS8,XS9); 
                    timer_on();
                    while((KA54_OFF | KA55_ON | KA56_ON) && time<20){}
                    KAR47_OFF
                    KAR105_OFF 
                    timer_off();
                    M = 0;
                    break;
                    
        case 41:    KAR103_ON
                    KAR47_ON
                    out(XS6,XS7,XS8,XS9); 
                    timer_on();
                    while((KA54_ON | KA55_OFF | KA56_ON) && time<20){}       
                    KAR47_OFF
                    KAR103_OFF 
                    timer_off();
                    M = 0;
                    break;
        
        case 42:    KAR104_ON
                    KAR47_ON
                    out(XS6,XS7,XS8,XS9); 
                    timer_on();
                    while((KA54_ON | KA55_ON | KA56_OFF) && time<20){}       
                    KAR47_OFF
                    KAR104_OFF 
                    timer_off();
                    M = 0;
                    break;
        
        default:    M = 0;  
    }
}
//------------------------------------------------------
//
//------------------------------------------------------
char scan(void)
{
    char ka5=0;
    
    if(KA551_ON && KA6_ON && KA8_ON && KA4_ON && KA3_ON && KA7_ON){ka5=1;HL6_ON}else{ka5=0;HL6_OFF}
    
    if(KA13_ON){KAR13_ON}else{KAR13_OFF}    
    
    if(KA30_ON){KAR30_ON}else{KAR30_OFF}    
    
    if(KA34_ON && ka5){KAR34_ON KAR100_ON}else{KAR34_OFF KAR100_OFF}//ON X,Z
     
    return ka5;                       
}
//------------------------------------------------------
//
//------------------------------------------------------
void out(unsigned char xs_6, unsigned char xs_7, unsigned char xs_8, unsigned char xs_9)
{
    static unsigned char first  = 0xFF;
    static unsigned char second = 0xFF;
    static unsigned char third  = 0xFF;
    static unsigned char fourth = 0xFF;
    
    if(first!=xs_6){
        PORTB&=~(1<<6); 
        SPDR = xs_6;
        while(!(SPSR & (1<<SPIF))){}
        PORTB|=(1<<6);
        first = xs_6;    
    }
    
    if(second!=xs_7){
        PORTB&=~(1<<5); 
        SPDR = xs_7;
        while(!(SPSR & (1<<SPIF))){}
        PORTB|=(1<<5);
        second = xs_7;    
    }
    
    if(third!=xs_8){
        PORTB&=~(1<<4); 
        SPDR = xs_8;
        while(!(SPSR & (1<<SPIF))){}
        PORTB|=(1<<4);
        third = xs_8;    
    }
    
    if(fourth!=xs_9){
        PORTB&=~(1<<0); 
        SPDR = xs_9;
        while(!(SPSR & (1<<SPIF))){}
        PORTB|=(1<<0);
        fourth = xs_9;    
    }
}
//------------------------------------------------------
//
//------------------------------------------------------
void led(void)
{
    //271 +24B
    if(KA3_ON){HL8_ON}else{HL8_OFF}                                                   
    
    if(KA4_ON){HL7_ON}else{HL7_OFF}
    
    if(KA8_ON){HL5_ON}else{HL5_OFF}
    
    if(KA11_ON){HL4_ON}else{HL4_OFF}
    
    if(KA54_ON){HL3_ON}else{HL3_OFF}//S 0     
    
    if(KA55_ON){HL2_ON}else{HL2_OFF}//S 1
    
    if(KA56_ON){HL1_ON}else{HL1_OFF}//S 2                                 
}
//------------------------------------------------------
//
//------------------------------------------------------
interrupt [TIM1_OVF] void timer1_ovf_isr(void)
{
    time++;
}
//------------------------------------------------------
//
//------------------------------------------------------
interrupt [TIM3_OVF] void timer3_ovf_isr(void)
{
    static int time_lubrication = 0;
    time_lubrication++;
    if(time_lubrication>600)
        time_lubrication = 0;
        
    if(time_lubrication>=0 && time_lubrication<30){//lubrication
        if(KA9_ON){
            KAR32_ON
        }else {
            KAR32_OFF
        }
    }    
}
//------------------------------------------------------
//
//------------------------------------------------------
void timer_on(void)
{ 
    time = 0;
    TCCR1A=0x00;
    TCCR1B=0x04;
    TCNT1H=0x00;
    TCNT1L=0x00;
}
//------------------------------------------------------
//
//------------------------------------------------------
void timer_off(void)
{
    time = 0;
    TCCR1A=0x00;
    TCCR1B=0x00;
    TCNT1H=0x00;
    TCNT1L=0x00;
}                        
//------------------------------------------------------
//
//------------------------------------------------------
void init(void){

PORTA=0x00;
DDRA=0x00;

PORTB=0b00000000;
DDRB=0b01110111;

PORTC=0x00;
DDRC=0x00;

PORTD=0x00;
DDRD=0x00;
 
PORTE=0x00;
DDRE=0x00;
 
PORTF=0b11111111;
DDRF=0x00;

// Port G initialization
// Func4=In Func3=In Func2=In Func1=In Func0=In 
// State4=T State3=T State2=T State1=T State0=T 
PORTG=0b11111;
DDRG=0x00;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
// Mode: Normal top=0xFF
// OC0 output: Disconnected
ASSR=0x00;
TCCR0=0x00;
TCNT0=0x00;
OCR0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer1 Stopped
// Mode: Normal top=0xFFFF
// OC1A output: Discon.
// OC1B output: Discon.
// OC1C output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
// Compare C Match Interrupt: Off
TCCR1A=0x00;
TCCR1B=0x00;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;
OCR1CH=0x00;
OCR1CL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=0xFF
// OC2 output: Disconnected
TCCR2=0x00;
TCNT2=0x00;
OCR2=0x00;

// Timer/Counter 3 initialization
// Clock source: System Clock
// Clock value: Timer3 Stopped
// Mode: Normal top=0xFFFF
// OC3A output: Discon.
// OC3B output: Discon.
// OC3C output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer3 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
// Compare C Match Interrupt: Off
TCCR3A=0x00;
TCCR3B=0x04;
TCNT3H=0x00;
TCNT3L=0x00;
ICR3H=0x00;
ICR3L=0x00;
OCR3AH=0x00;
OCR3AL=0x00;
OCR3BH=0x00;
OCR3BL=0x00;
OCR3CH=0x00;
OCR3CL=0x00;

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// INT2: Off
// INT3: Off
// INT4: Off
// INT5: Off
// INT6: Off
// INT7: Off
EICRA=0x00;
EICRB=0x00;
EIMSK=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x04;

ETIMSK=0x04;

// USART0 initialization
// USART0 disabled
UCSR0B=0x00;

// USART1 initialization
// USART1 disabled
UCSR1B=0x00;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

// ADC initialization
// ADC disabled
ADCSRA=0x00;

// SPI initialization
// SPI Type: Master
// SPI Clock Rate: 125,000 kHz
// SPI Clock Phase: Cycle Start
// SPI Clock Polarity: High
// SPI Data Order: MSB First
SPCR=0x53;//5B
SPSR=0x00;

// TWI initialization
// TWI disabled
TWCR=0x00;
#asm("sei")
}
//------------------------------------------------------
//
//------------------------------------------------------