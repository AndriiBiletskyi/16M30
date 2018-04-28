
;CodeVisionAVR C Compiler V2.05.3 Standard
;(C) Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega64A
;Program type             : Application
;Clock frequency          : 16,000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 1024 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;Global 'const' stored in FLASH     : No
;Enhanced function parameter passing: Yes
;Enhanced core instructions         : On
;Smart register allocation          : On
;Automatic register allocation      : On

	#pragma AVRPART ADMIN PART_NAME ATmega64A
	#pragma AVRPART MEMORY PROG_FLASH 65536
	#pragma AVRPART MEMORY EEPROM 2048
	#pragma AVRPART MEMORY INT_SRAM SIZE 4351
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU XMCRA=0x6D
	.EQU XMCRB=0x6C

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x10FF
	.EQU __DSTACK_SIZE=0x0400
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _time=R4
	.DEF _XS6=R7
	.DEF _XS7=R6
	.DEF _XS8=R9
	.DEF _XS9=R8

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer1_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer3_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_0x6B:
	.DB  0xFF
_0x6C:
	.DB  0xFF
_0x6D:
	.DB  0xFF
_0x6E:
	.DB  0xFF
_0x94:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  _first_S0000003000
	.DW  _0x6B*2

	.DW  0x01
	.DW  _second_S0000003000
	.DW  _0x6C*2

	.DW  0x01
	.DW  _third_S0000003000
	.DW  _0x6D*2

	.DW  0x01
	.DW  _fourth_S0000003000
	.DW  _0x6E*2

	.DW  0x06
	.DW  0x04
	.DW  _0x94*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30
	STS  XMCRB,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x500

	.CSEG
;/*****************************************************
;Chip type               : ATmega64A
;Program type            : Application
;AVR Core Clock frequency: 16,000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 1024
;*****************************************************/
;
;#include <mega64a.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include <spi.h>
;
;//-----------------------------------------------------------------------
;#define KA1_ON          (PINA.6==0)//контроль заданной скорости 5.23
;#define KA1_OFF         (PINA.6==1)
;#define KA2_ON          (PINA.7==0)//тепловая защита 8.6
;#define KA2_OFF         (PINA.7==1)
;#define KA3_ON          (PINA.4==0)//готовность шпинделя 8.13
;#define KA3_OFF         (PINA.4==1)
;#define KA4_ON          (PINA.5==0)//готовность подач 8.20
;#define KA4_OFF         (PINA.5==1)
;#define KA551_ON        (PINA.2==0)//контроль поджима пиноли,давление пневмосистемы 9.11
;#define KA551_OFF       (PINA.2==1)
;#define KA6_ON          (PINF.2==0)//ограничение Х 9.17
;#define KA6_OFF         (PINF.2==1)
;#define KA7_ON          (PINF.3==0)//ограничение Z 9.19
;#define KA7_OFF         (PINF.3==1)
;#define KA8_ON          (PINC.4==0)//контроль смазки 10.19
;#define KA8_OFF         (PINC.4==1)
;#define KA9_ON          (PINC.3==0)//контроль дозаторной смазки 11.22
;#define KA9_OFF         (PINC.3==1)
;#define KA11_ON         (PINF.4==0)//контроль посадки 16.10
;#define KA11_OFF        (PINF.4==1)
;
;#define SQ7_ON          (PINF.5==0)//T1
;#define SQ7_OFF         (PINF.5==1)//T1
;#define SQ8_ON          (PINF.6==0)//T2
;#define SQ8_OFF         (PINF.6==1)//T2
;#define SQ9_ON          (PINF.7==0)//T3
;#define SQ9_OFF         (PINF.7==1)//T3
;#define SQ10_ON         (PINA.0==0)//T4
;#define SQ10_OFF        (PINA.0==1)//T4
;#define K1_ON           (PINC.7==0)//Current
;#define K1_OFF          (PINC.7==1)
;
;#define KA13_ON         (PINC.2==0)//контроль давления прижима 18.3
;#define KA13_OFF        (PINC.2==1)
;
;#define KA22_ON         (PIND.0==0)//1
;#define KA22_OFF        (PIND.0==1)
;#define KA23_ON         (PIND.1==0)//2
;#define KA23_OFF        (PIND.1==1)
;#define KA24_ON         (PIND.2==0)//4
;#define KA24_OFF        (PIND.2==1)
;#define KA25_ON         (PIND.3==0)//8
;#define KA25_OFF        (PIND.3==1)
;#define KA26_ON         (PIND.4==0)//40
;#define KA26_OFF        (PIND.4==1)
;#define KA27_ON         (PIND.5==0)//M
;#define KA27_OFF        (PIND.5==1)
;#define KA29_ON         (PIND.6==0)//T
;#define KA29_OFF        (PIND.6==1)
;#define KA30_ON         (PIND.7==0)//Автомат режим
;#define KA30_OFF        (PIND.7==1)
;#define KA31_ON         (PINF.1==0)//Ручной режим
;#define KA31_OFF        (PINF.1==1)
;#define KA32_ON         (PINF.0==0)//Импульсная смазка
;#define KA32_OFF        (PINF.0==1)
;#define KA33_ON         (PINE.2==0)//Считывание
;#define KA33_OFF        (PINE.2==1)
;#define KA34_ON         (PINE.3==0)//CNC normal 23.15
;#define KA34_OFF        (PINE.3==1)
;#define KA54_ON         (PINC.1==0)//S 0
;#define KA54_OFF        (PINC.1==1)
;#define KA55_ON         (PINC.0==0)//S 1
;#define KA55_OFF        (PINC.0==1)
;#define KA56_ON         (PINC.5==0)//S 2
;#define KA56_OFF        (PINC.5==1)
;//------------------------------------------------------
;#define KAR47_ON         XS6|=(1<<0);//ON S
;#define KAR47_OFF        XS6&=~(1<<0);
;#define KAR100_ON        XS6|=(1<<1);//ON X,Z
;#define KAR100_OFF       XS6&=~(1<<1);
;#define KAR30_ON         XS6|=(1<<2);//AUTO
;#define KAR30_OFF        XS6&=~(1<<2);
;#define KAR32_ON         XS7|=(1<<0);//ON Oil
;#define KAR32_OFF        XS7&=~(1<<0);
;#define KAR45_ON         XS6|=(1<<3);//ON Cool_1
;#define KAR45_OFF        XS6&=~(1<<3);
;#define KAR46_ON         XS6|=(1<<4);//ON Cool_2
;#define KAR46_OFF        XS6&=~(1<<4);
;#define KAR12_ON         XS7|=(1<<1);//CW_T
;#define KAR12_OFF        XS7&=~(1<<1);//CCW_T
;#define KAR10_ON         XS7|=(1<<2);//ON T
;#define KAR10_OFF        XS7&=~(1<<2);//OFF T
;#define KAR13_ON         XS7|=(1<<3);
;#define KAR13_OFF        XS7&=~(1<<3);
;#define KAR103_ON        XS7|=(1<<4);//S 1
;#define KAR103_OFF       XS7&=~(1<<4);
;#define KAR104_ON        XS7|=(1<<5);//S 2
;#define KAR104_OFF       XS7&=~(1<<5);
;#define KAR105_ON        XS7|=(1<<6);//S 0
;#define KAR105_OFF       XS7&=~(1<<6);
;#define KAR107_ON        XS6|=(1<<5);//ON RVK
;#define KAR107_OFF       XS6&=~(1<<5);
;#define KAR34_ON         XS6|=(1<<6);//Ready turn
;#define KAR34_OFF        XS6&=~(1<<6);
;//------------------------------------------------------
;#define HL8_ON           XS8|=(1<<0);
;#define HL8_OFF          XS8&=~(1<<0);
;#define HL7_ON           XS8|=(1<<1);
;#define HL7_OFF          XS8&=~(1<<1);
;#define HL6_ON           XS8|=(1<<2);
;#define HL6_OFF          XS8&=~(1<<2);
;#define HL5_ON           XS8|=(1<<3);
;#define HL5_OFF          XS8&=~(1<<3);
;#define HL4_ON           XS8|=(1<<4);
;#define HL4_OFF          XS8&=~(1<<4);
;#define HL3_ON           XS8|=(1<<5);
;#define HL3_OFF          XS8&=~(1<<5);
;#define HL2_ON           XS8|=(1<<6);
;#define HL2_OFF          XS8&=~(1<<6);
;#define HL1_ON           XS8|=(1<<7);
;#define HL1_OFF          XS8&=~(1<<7);
;//------------------------------------------------------
;int time=0;
;unsigned char XS6=0,XS7=0,XS8=0,XS9=0;
;//------------------------------------------------------
;void init(void);//Initialization of the entire periphery
;interrupt [TIM3_OVF] void timer3_ovf_isr(void);//lubrication
;interrupt [TIM1_OVF] void timer1_ovf_isr(void);//counting time
;void timer_on(void);//enable timer 1 (counting time)
;void timer_off(void);//disable timer 1 (counting time)
;void out(unsigned char xs_6, unsigned char xs_7, unsigned char xs_8, unsigned char xs_9);//set outputs
;void led(void);//enable/disable leds
;void m_t(char enable);//processing M,T-commands
;char scan(void);//input processing
;//------------------------------------------------------
;//
;//------------------------------------------------------
;void main(void)
; 0000 008F {

	.CSEG
_main:
; 0000 0090     init();
	RCALL _init
; 0000 0091     out(XS6,XS7,XS8,XS9);
	CALL SUBOPT_0x0
; 0000 0092     KAR12_ON
	LDI  R30,LOW(2)
	OR   R6,R30
; 0000 0093     KAR10_ON
	LDI  R30,LOW(4)
	OR   R6,R30
; 0000 0094     out(XS6,XS7,XS8,XS9);
	CALL SUBOPT_0x0
; 0000 0095     delay_ms(100);
	LDI  R26,LOW(100)
	LDI  R27,0
	CALL _delay_ms
; 0000 0096     KAR10_OFF
	CALL SUBOPT_0x1
; 0000 0097     KAR12_OFF
; 0000 0098     out(XS6,XS7,XS8,XS9);
; 0000 0099 
; 0000 009A while (1)
_0x3:
; 0000 009B       {
; 0000 009C         m_t(scan());
	RCALL _scan
	MOV  R26,R30
	RCALL _m_t
; 0000 009D         led();
	RCALL _led
; 0000 009E         out(XS6,XS7,XS8,XS9);
	CALL SUBOPT_0x0
; 0000 009F       }
	RJMP _0x3
; 0000 00A0 }
_0x6:
	RJMP _0x6
;//------------------------------------------------------
;//
;//------------------------------------------------------
;void m_t(char enable)
; 0000 00A5 {
_m_t:
; 0000 00A6     int ka22 = 0;
; 0000 00A7     int ka23 = 0;
; 0000 00A8     int ka24 = 0;
; 0000 00A9     int ka25 = 0;
; 0000 00AA     int ka26 = 0;
; 0000 00AB     static int M=0;
; 0000 00AC     static int T=0;
; 0000 00AD     static int KOD=0;
; 0000 00AE 
; 0000 00AF     if(KA22_ON){ka22=1;}else{ka22=0;}//1
	ST   -Y,R26
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	STD  Y+2,R30
	STD  Y+3,R30
	CALL __SAVELOCR6
;	enable -> Y+10
;	ka22 -> R16,R17
;	ka23 -> R18,R19
;	ka24 -> R20,R21
;	ka25 -> Y+8
;	ka26 -> Y+6
	__GETWRN 16,17,0
	__GETWRN 18,19,0
	__GETWRN 20,21,0
	SBIC 0x10,0
	RJMP _0x7
	__GETWRN 16,17,1
	RJMP _0x8
_0x7:
	__GETWRN 16,17,0
_0x8:
; 0000 00B0 
; 0000 00B1     if(KA23_ON){ka23=1;}else{ka23=0;}//2
	SBIC 0x10,1
	RJMP _0x9
	__GETWRN 18,19,1
	RJMP _0xA
_0x9:
	__GETWRN 18,19,0
_0xA:
; 0000 00B2 
; 0000 00B3     if(KA24_ON){ka24=1;}else{ka24=0;}//4
	SBIC 0x10,2
	RJMP _0xB
	__GETWRN 20,21,1
	RJMP _0xC
_0xB:
	__GETWRN 20,21,0
_0xC:
; 0000 00B4 
; 0000 00B5     if(KA25_ON){ka25=1;}else{ka25=0;}//8
	SBIC 0x10,3
	RJMP _0xD
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STD  Y+8,R30
	STD  Y+8+1,R31
	RJMP _0xE
_0xD:
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
_0xE:
; 0000 00B6 
; 0000 00B7     if(KA26_ON){ka26=1;}else{ka26=0;}//40
	SBIC 0x10,4
	RJMP _0xF
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x10
_0xF:
	LDI  R30,LOW(0)
	STD  Y+6,R30
	STD  Y+6+1,R30
_0x10:
; 0000 00B8 
; 0000 00B9     KOD = ka22 + 2*ka23 + 4*ka24 + 8*ka25 + 40*ka26;
	MOVW R30,R18
	LSL  R30
	ROL  R31
	ADD  R30,R16
	ADC  R31,R17
	MOVW R26,R30
	MOVW R30,R20
	CALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	CALL __LSLW3
	ADD  R30,R26
	ADC  R31,R27
	MOVW R22,R30
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LDI  R26,LOW(40)
	LDI  R27,HIGH(40)
	CALL __MULW12
	ADD  R30,R22
	ADC  R31,R23
	STS  _KOD_S0000001000,R30
	STS  _KOD_S0000001000+1,R31
; 0000 00BA 
; 0000 00BB     if(KA33_ON){
	SBIC 0x1,2
	RJMP _0x11
; 0000 00BC         if(KA27_ON)M = KOD;
	SBIC 0x10,5
	RJMP _0x12
	LDS  R30,_KOD_S0000001000
	LDS  R31,_KOD_S0000001000+1
	STS  _M_S0000001000,R30
	STS  _M_S0000001000+1,R31
; 0000 00BD         if(KA29_ON)T = KOD;
_0x12:
	SBIC 0x10,6
	RJMP _0x13
	LDS  R30,_KOD_S0000001000
	LDS  R31,_KOD_S0000001000+1
	STS  _T_S0000001000,R30
	STS  _T_S0000001000+1,R31
; 0000 00BE     }
_0x13:
; 0000 00BF 
; 0000 00C0     if(KA8_ON && M!=6 && KA9_ON && KA11_ON && !KA27_ON && !KA29_ON){KAR107_ON}else{KAR107_OFF}//RVK
_0x11:
	LDI  R26,0
	SBIC 0x13,4
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BRNE _0x15
	LDS  R26,_M_S0000001000
	LDS  R27,_M_S0000001000+1
	SBIW R26,6
	BREQ _0x15
	LDI  R26,0
	SBIC 0x13,3
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BRNE _0x15
	LDI  R26,0
	SBIC 0x0,4
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BRNE _0x15
	LDI  R26,0
	SBIC 0x10,5
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BREQ _0x15
	LDI  R26,0
	SBIC 0x10,6
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BRNE _0x16
_0x15:
	RJMP _0x14
_0x16:
	LDI  R30,LOW(32)
	OR   R7,R30
	RJMP _0x17
_0x14:
	LDI  R30,LOW(223)
	AND  R7,R30
_0x17:
; 0000 00C1 
; 0000 00C2     switch(M){
	LDS  R30,_M_S0000001000
	LDS  R31,_M_S0000001000+1
; 0000 00C3         case 3:     if(enable)
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x1B
	LDD  R30,Y+10
	CPI  R30,0
	BREQ _0x1C
; 0000 00C4                         KAR47_ON//ON S
	LDI  R30,LOW(1)
	OR   R7,R30
; 0000 00C5                     M = 0;
_0x1C:
	RJMP _0x93
; 0000 00C6                     break;
; 0000 00C7 
; 0000 00C8         case 4:     if(enable)
_0x1B:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x1D
	LDD  R30,Y+10
	CPI  R30,0
	BREQ _0x1E
; 0000 00C9                         KAR47_ON//ON S
	LDI  R30,LOW(1)
	OR   R7,R30
; 0000 00CA                     M = 0;
_0x1E:
	RJMP _0x93
; 0000 00CB                     break;
; 0000 00CC 
; 0000 00CD         case 5:     KAR47_OFF//OFF S
_0x1D:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x1F
	LDI  R30,LOW(254)
	AND  R7,R30
; 0000 00CE                     M = 0;
	RJMP _0x93
; 0000 00CF                     break;
; 0000 00D0 
; 0000 00D1         case 6:     KAR10_ON
_0x1F:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x20
	LDI  R30,LOW(4)
	OR   R6,R30
; 0000 00D2                     out(XS6,XS7,XS8,XS9);
	RCALL SUBOPT_0x0
; 0000 00D3                     timer_on();
	RCALL _timer_on
; 0000 00D4                     if(T==1){
	RCALL SUBOPT_0x2
	SBIW R26,1
	BRNE _0x21
; 0000 00D5                       while(SQ7_OFF && time<20){
_0x22:
	SBIS 0x0,5
	RJMP _0x25
	RCALL SUBOPT_0x3
	BRLT _0x26
_0x25:
	RJMP _0x24
_0x26:
; 0000 00D6                         if(KA11_ON){HL4_ON}else{HL4_OFF}
	SBIC 0x0,4
	RJMP _0x27
	LDI  R30,LOW(16)
	OR   R9,R30
	RJMP _0x28
_0x27:
	LDI  R30,LOW(239)
	AND  R9,R30
_0x28:
; 0000 00D7                         out(XS6,XS7,XS8,XS9);
	RCALL SUBOPT_0x0
; 0000 00D8                       }
	RJMP _0x22
_0x24:
; 0000 00D9                     }
; 0000 00DA                     if(T==2){
_0x21:
	RCALL SUBOPT_0x2
	SBIW R26,2
	BRNE _0x29
; 0000 00DB                       while(SQ8_OFF && time<20){
_0x2A:
	SBIS 0x0,6
	RJMP _0x2D
	RCALL SUBOPT_0x3
	BRLT _0x2E
_0x2D:
	RJMP _0x2C
_0x2E:
; 0000 00DC                         if(KA11_ON){HL4_ON}else{HL4_OFF}
	SBIC 0x0,4
	RJMP _0x2F
	LDI  R30,LOW(16)
	OR   R9,R30
	RJMP _0x30
_0x2F:
	LDI  R30,LOW(239)
	AND  R9,R30
_0x30:
; 0000 00DD                         out(XS6,XS7,XS8,XS9);
	RCALL SUBOPT_0x0
; 0000 00DE                       }
	RJMP _0x2A
_0x2C:
; 0000 00DF                     }
; 0000 00E0                     if(T==3){
_0x29:
	RCALL SUBOPT_0x2
	SBIW R26,3
	BRNE _0x31
; 0000 00E1                       while(SQ9_OFF && time<20){
_0x32:
	SBIS 0x0,7
	RJMP _0x35
	RCALL SUBOPT_0x3
	BRLT _0x36
_0x35:
	RJMP _0x34
_0x36:
; 0000 00E2                         if(KA11_ON){HL4_ON}else{HL4_OFF}
	SBIC 0x0,4
	RJMP _0x37
	LDI  R30,LOW(16)
	OR   R9,R30
	RJMP _0x38
_0x37:
	LDI  R30,LOW(239)
	AND  R9,R30
_0x38:
; 0000 00E3                         out(XS6,XS7,XS8,XS9);
	RCALL SUBOPT_0x0
; 0000 00E4                       }
	RJMP _0x32
_0x34:
; 0000 00E5                     }
; 0000 00E6                     if(T==4){
_0x31:
	RCALL SUBOPT_0x2
	SBIW R26,4
	BRNE _0x39
; 0000 00E7                       while(SQ10_OFF && time<20){
_0x3A:
	SBIS 0x19,0
	RJMP _0x3D
	RCALL SUBOPT_0x3
	BRLT _0x3E
_0x3D:
	RJMP _0x3C
_0x3E:
; 0000 00E8                         if(KA11_ON){HL4_ON}else{HL4_OFF}
	SBIC 0x0,4
	RJMP _0x3F
	LDI  R30,LOW(16)
	OR   R9,R30
	RJMP _0x40
_0x3F:
	LDI  R30,LOW(239)
	AND  R9,R30
_0x40:
; 0000 00E9                         out(XS6,XS7,XS8,XS9);
	RCALL SUBOPT_0x0
; 0000 00EA                       }
	RJMP _0x3A
_0x3C:
; 0000 00EB                     }
; 0000 00EC 
; 0000 00ED                     if(time<20){
_0x39:
	RCALL SUBOPT_0x3
	BRGE _0x41
; 0000 00EE                         timer_off();
	RCALL _timer_off
; 0000 00EF                         KAR12_ON
	LDI  R30,LOW(2)
	OR   R6,R30
; 0000 00F0                         out(XS6,XS7,XS8,XS9);
	RCALL SUBOPT_0x0
; 0000 00F1                         timer_on();
	RCALL _timer_on
; 0000 00F2                         while((K1_OFF | KA11_OFF) && time<20){
_0x42:
	LDI  R26,0
	SBIC 0x13,7
	LDI  R26,1
	LDI  R30,LOW(1)
	CALL __EQB12
	MOV  R0,R30
	LDI  R26,0
	SBIC 0x0,4
	LDI  R26,1
	LDI  R30,LOW(1)
	CALL __EQB12
	OR   R30,R0
	BREQ _0x45
	RCALL SUBOPT_0x3
	BRLT _0x46
_0x45:
	RJMP _0x44
_0x46:
; 0000 00F3                             if(KA11_ON){HL4_ON}else{HL4_OFF}
	SBIC 0x0,4
	RJMP _0x47
	LDI  R30,LOW(16)
	OR   R9,R30
	RJMP _0x48
_0x47:
	LDI  R30,LOW(239)
	AND  R9,R30
_0x48:
; 0000 00F4                             out(XS6,XS7,XS8,XS9);
	RCALL SUBOPT_0x0
; 0000 00F5                         }
	RJMP _0x42
_0x44:
; 0000 00F6                         KAR10_OFF
	RCALL SUBOPT_0x1
; 0000 00F7                         KAR12_OFF
; 0000 00F8                         out(XS6,XS7,XS8,XS9);
; 0000 00F9                         timer_off();
	RCALL _timer_off
; 0000 00FA                     }
; 0000 00FB 
; 0000 00FC                     KAR10_OFF
_0x41:
	RCALL SUBOPT_0x1
; 0000 00FD                     KAR12_OFF
; 0000 00FE                     out(XS6,XS7,XS8,XS9);
; 0000 00FF                     timer_off();
	RCALL _timer_off
; 0000 0100                     M = 0;
	RJMP _0x93
; 0000 0101                     break;
; 0000 0102 
; 0000 0103         case 7:     KAR45_ON
_0x20:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x49
	LDI  R30,LOW(8)
	OR   R7,R30
; 0000 0104                     M = 0;
	RJMP _0x93
; 0000 0105                     break;
; 0000 0106 
; 0000 0107         case 8:     KAR46_ON
_0x49:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x4A
	LDI  R30,LOW(16)
	OR   R7,R30
; 0000 0108                     M = 0;
	RJMP _0x93
; 0000 0109                     break;
; 0000 010A 
; 0000 010B         case 9:     KAR46_OFF
_0x4A:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x4B
	LDI  R30,LOW(239)
	AND  R7,R30
; 0000 010C                     KAR45_OFF
	LDI  R30,LOW(247)
	AND  R7,R30
; 0000 010D                     M = 0;
	RJMP _0x93
; 0000 010E                     break;
; 0000 010F 
; 0000 0110         case 40:    KAR105_ON
_0x4B:
	CPI  R30,LOW(0x28)
	LDI  R26,HIGH(0x28)
	CPC  R31,R26
	BRNE _0x4C
	LDI  R30,LOW(64)
	RCALL SUBOPT_0x4
; 0000 0111                     KAR47_ON
; 0000 0112                     out(XS6,XS7,XS8,XS9);
; 0000 0113                     timer_on();
	RCALL _timer_on
; 0000 0114                     while((KA54_OFF | KA55_ON | KA56_ON) && time<20){}
_0x4D:
	LDI  R26,0
	SBIC 0x13,1
	LDI  R26,1
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x6
	LDI  R30,LOW(0)
	CALL __EQB12
	OR   R30,R0
	BREQ _0x50
	RCALL SUBOPT_0x3
	BRLT _0x51
_0x50:
	RJMP _0x4F
_0x51:
	RJMP _0x4D
_0x4F:
; 0000 0115                     KAR47_OFF
	LDI  R30,LOW(254)
	AND  R7,R30
; 0000 0116                     KAR105_OFF
	LDI  R30,LOW(191)
	AND  R6,R30
; 0000 0117                     timer_off();
	RCALL _timer_off
; 0000 0118                     M = 0;
	RJMP _0x93
; 0000 0119                     break;
; 0000 011A 
; 0000 011B         case 41:    KAR103_ON
_0x4C:
	CPI  R30,LOW(0x29)
	LDI  R26,HIGH(0x29)
	CPC  R31,R26
	BRNE _0x52
	LDI  R30,LOW(16)
	RCALL SUBOPT_0x4
; 0000 011C                     KAR47_ON
; 0000 011D                     out(XS6,XS7,XS8,XS9);
; 0000 011E                     timer_on();
	RCALL _timer_on
; 0000 011F                     while((KA54_ON | KA55_OFF | KA56_ON) && time<20){}
_0x53:
	RCALL SUBOPT_0x7
	LDI  R30,LOW(1)
	CALL __EQB12
	OR   R0,R30
	LDI  R26,0
	SBIC 0x13,5
	LDI  R26,1
	LDI  R30,LOW(0)
	CALL __EQB12
	OR   R30,R0
	BREQ _0x56
	RCALL SUBOPT_0x3
	BRLT _0x57
_0x56:
	RJMP _0x55
_0x57:
	RJMP _0x53
_0x55:
; 0000 0120                     KAR47_OFF
	LDI  R30,LOW(254)
	AND  R7,R30
; 0000 0121                     KAR103_OFF
	LDI  R30,LOW(239)
	AND  R6,R30
; 0000 0122                     timer_off();
	RCALL _timer_off
; 0000 0123                     M = 0;
	RJMP _0x93
; 0000 0124                     break;
; 0000 0125 
; 0000 0126         case 42:    KAR104_ON
_0x52:
	CPI  R30,LOW(0x2A)
	LDI  R26,HIGH(0x2A)
	CPC  R31,R26
	BRNE _0x5E
	LDI  R30,LOW(32)
	RCALL SUBOPT_0x4
; 0000 0127                     KAR47_ON
; 0000 0128                     out(XS6,XS7,XS8,XS9);
; 0000 0129                     timer_on();
	RCALL _timer_on
; 0000 012A                     while((KA54_ON | KA55_ON | KA56_OFF) && time<20){}
_0x59:
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x6
	LDI  R30,LOW(1)
	CALL __EQB12
	OR   R30,R0
	BREQ _0x5C
	RCALL SUBOPT_0x3
	BRLT _0x5D
_0x5C:
	RJMP _0x5B
_0x5D:
	RJMP _0x59
_0x5B:
; 0000 012B                     KAR47_OFF
	LDI  R30,LOW(254)
	AND  R7,R30
; 0000 012C                     KAR104_OFF
	LDI  R30,LOW(223)
	AND  R6,R30
; 0000 012D                     timer_off();
	RCALL _timer_off
; 0000 012E                     M = 0;
; 0000 012F                     break;
; 0000 0130 
; 0000 0131         default:    M = 0;
_0x5E:
_0x93:
	LDI  R30,LOW(0)
	STS  _M_S0000001000,R30
	STS  _M_S0000001000+1,R30
; 0000 0132     }
; 0000 0133 }
	CALL __LOADLOCR6
	ADIW R28,11
	RET
;//------------------------------------------------------
;//
;//------------------------------------------------------
;char scan(void)
; 0000 0138 {
_scan:
; 0000 0139     char ka5=0;
; 0000 013A 
; 0000 013B     if(KA551_ON && KA6_ON && KA8_ON && KA4_ON && KA3_ON && KA7_ON){ka5=1;HL6_ON}else{ka5=0;HL6_OFF}
	ST   -Y,R17
;	ka5 -> R17
	LDI  R17,0
	LDI  R26,0
	SBIC 0x19,2
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BRNE _0x60
	LDI  R26,0
	SBIC 0x0,2
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BRNE _0x60
	LDI  R26,0
	SBIC 0x13,4
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BRNE _0x60
	LDI  R26,0
	SBIC 0x19,5
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BRNE _0x60
	LDI  R26,0
	SBIC 0x19,4
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BRNE _0x60
	LDI  R26,0
	SBIC 0x0,3
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BREQ _0x61
_0x60:
	RJMP _0x5F
_0x61:
	LDI  R17,LOW(1)
	LDI  R30,LOW(4)
	OR   R9,R30
	RJMP _0x62
_0x5F:
	LDI  R17,LOW(0)
	LDI  R30,LOW(251)
	AND  R9,R30
_0x62:
; 0000 013C 
; 0000 013D     if(KA13_ON){KAR13_ON}else{KAR13_OFF}
	SBIC 0x13,2
	RJMP _0x63
	LDI  R30,LOW(8)
	OR   R6,R30
	RJMP _0x64
_0x63:
	LDI  R30,LOW(247)
	AND  R6,R30
_0x64:
; 0000 013E 
; 0000 013F     if(KA30_ON){KAR30_ON}else{KAR30_OFF}
	SBIC 0x10,7
	RJMP _0x65
	LDI  R30,LOW(4)
	OR   R7,R30
	RJMP _0x66
_0x65:
	LDI  R30,LOW(251)
	AND  R7,R30
_0x66:
; 0000 0140 
; 0000 0141     if(KA34_ON && ka5){KAR34_ON KAR100_ON}else{KAR34_OFF KAR100_OFF}//ON X,Z
	LDI  R26,0
	SBIC 0x1,3
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BRNE _0x68
	CPI  R17,0
	BRNE _0x69
_0x68:
	RJMP _0x67
_0x69:
	LDI  R30,LOW(64)
	OR   R7,R30
	LDI  R30,LOW(2)
	OR   R7,R30
	RJMP _0x6A
_0x67:
	LDI  R30,LOW(191)
	AND  R7,R30
	LDI  R30,LOW(253)
	AND  R7,R30
_0x6A:
; 0000 0142 
; 0000 0143     return ka5;
	MOV  R30,R17
	LD   R17,Y+
	RET
; 0000 0144 }
;//------------------------------------------------------
;//
;//------------------------------------------------------
;void out(unsigned char xs_6, unsigned char xs_7, unsigned char xs_8, unsigned char xs_9)
; 0000 0149 {
_out:
; 0000 014A     static unsigned char first  = 0xFF;

	.DSEG

	.CSEG
; 0000 014B     static unsigned char second = 0xFF;

	.DSEG

	.CSEG
; 0000 014C     static unsigned char third  = 0xFF;

	.DSEG

	.CSEG
; 0000 014D     static unsigned char fourth = 0xFF;

	.DSEG

	.CSEG
; 0000 014E 
; 0000 014F     if(first!=xs_6){
	ST   -Y,R26
;	xs_6 -> Y+3
;	xs_7 -> Y+2
;	xs_8 -> Y+1
;	xs_9 -> Y+0
	LDD  R30,Y+3
	LDS  R26,_first_S0000003000
	CP   R30,R26
	BREQ _0x6F
; 0000 0150         PORTB&=~(1<<6);
	CBI  0x18,6
; 0000 0151         SPDR = xs_6;
	OUT  0xF,R30
; 0000 0152         while(!(SPSR & (1<<SPIF))){}
_0x70:
	SBIS 0xE,7
	RJMP _0x70
; 0000 0153         PORTB|=(1<<6);
	SBI  0x18,6
; 0000 0154         first = xs_6;
	LDD  R30,Y+3
	STS  _first_S0000003000,R30
; 0000 0155     }
; 0000 0156 
; 0000 0157     if(second!=xs_7){
_0x6F:
	LDD  R30,Y+2
	LDS  R26,_second_S0000003000
	CP   R30,R26
	BREQ _0x73
; 0000 0158         PORTB&=~(1<<5);
	CBI  0x18,5
; 0000 0159         SPDR = xs_7;
	OUT  0xF,R30
; 0000 015A         while(!(SPSR & (1<<SPIF))){}
_0x74:
	SBIS 0xE,7
	RJMP _0x74
; 0000 015B         PORTB|=(1<<5);
	SBI  0x18,5
; 0000 015C         second = xs_7;
	LDD  R30,Y+2
	STS  _second_S0000003000,R30
; 0000 015D     }
; 0000 015E 
; 0000 015F     if(third!=xs_8){
_0x73:
	LDD  R30,Y+1
	LDS  R26,_third_S0000003000
	CP   R30,R26
	BREQ _0x77
; 0000 0160         PORTB&=~(1<<4);
	CBI  0x18,4
; 0000 0161         SPDR = xs_8;
	OUT  0xF,R30
; 0000 0162         while(!(SPSR & (1<<SPIF))){}
_0x78:
	SBIS 0xE,7
	RJMP _0x78
; 0000 0163         PORTB|=(1<<4);
	SBI  0x18,4
; 0000 0164         third = xs_8;
	LDD  R30,Y+1
	STS  _third_S0000003000,R30
; 0000 0165     }
; 0000 0166 
; 0000 0167     if(fourth!=xs_9){
_0x77:
	LD   R30,Y
	LDS  R26,_fourth_S0000003000
	CP   R30,R26
	BREQ _0x7B
; 0000 0168         PORTB&=~(1<<0);
	CBI  0x18,0
; 0000 0169         SPDR = xs_9;
	OUT  0xF,R30
; 0000 016A         while(!(SPSR & (1<<SPIF))){}
_0x7C:
	SBIS 0xE,7
	RJMP _0x7C
; 0000 016B         PORTB|=(1<<0);
	SBI  0x18,0
; 0000 016C         fourth = xs_9;
	LD   R30,Y
	STS  _fourth_S0000003000,R30
; 0000 016D     }
; 0000 016E }
_0x7B:
	ADIW R28,4
	RET
;//------------------------------------------------------
;//
;//------------------------------------------------------
;void led(void)
; 0000 0173 {
_led:
; 0000 0174     //271 +24B
; 0000 0175     if(KA3_ON){HL8_ON}else{HL8_OFF}
	SBIC 0x19,4
	RJMP _0x7F
	LDI  R30,LOW(1)
	OR   R9,R30
	RJMP _0x80
_0x7F:
	LDI  R30,LOW(254)
	AND  R9,R30
_0x80:
; 0000 0176 
; 0000 0177     if(KA4_ON){HL7_ON}else{HL7_OFF}
	SBIC 0x19,5
	RJMP _0x81
	LDI  R30,LOW(2)
	OR   R9,R30
	RJMP _0x82
_0x81:
	LDI  R30,LOW(253)
	AND  R9,R30
_0x82:
; 0000 0178 
; 0000 0179     if(KA8_ON){HL5_ON}else{HL5_OFF}
	SBIC 0x13,4
	RJMP _0x83
	LDI  R30,LOW(8)
	OR   R9,R30
	RJMP _0x84
_0x83:
	LDI  R30,LOW(247)
	AND  R9,R30
_0x84:
; 0000 017A 
; 0000 017B     if(KA11_ON){HL4_ON}else{HL4_OFF}
	SBIC 0x0,4
	RJMP _0x85
	LDI  R30,LOW(16)
	OR   R9,R30
	RJMP _0x86
_0x85:
	LDI  R30,LOW(239)
	AND  R9,R30
_0x86:
; 0000 017C 
; 0000 017D     if(KA54_ON){HL3_ON}else{HL3_OFF}//S 0
	SBIC 0x13,1
	RJMP _0x87
	LDI  R30,LOW(32)
	OR   R9,R30
	RJMP _0x88
_0x87:
	LDI  R30,LOW(223)
	AND  R9,R30
_0x88:
; 0000 017E 
; 0000 017F     if(KA55_ON){HL2_ON}else{HL2_OFF}//S 1
	SBIC 0x13,0
	RJMP _0x89
	LDI  R30,LOW(64)
	OR   R9,R30
	RJMP _0x8A
_0x89:
	LDI  R30,LOW(191)
	AND  R9,R30
_0x8A:
; 0000 0180 
; 0000 0181     if(KA56_ON){HL1_ON}else{HL1_OFF}//S 2
	SBIC 0x13,5
	RJMP _0x8B
	LDI  R30,LOW(128)
	OR   R9,R30
	RJMP _0x8C
_0x8B:
	LDI  R30,LOW(127)
	AND  R9,R30
_0x8C:
; 0000 0182 }
	RET
;//------------------------------------------------------
;//
;//------------------------------------------------------
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
; 0000 0187 {
_timer1_ovf_isr:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0188     time++;
	MOVW R30,R4
	ADIW R30,1
	MOVW R4,R30
; 0000 0189 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
;//------------------------------------------------------
;//
;//------------------------------------------------------
;interrupt [TIM3_OVF] void timer3_ovf_isr(void)
; 0000 018E {
_timer3_ovf_isr:
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 018F     static int time_lubrication = 0;
; 0000 0190     time_lubrication++;
	LDI  R26,LOW(_time_lubrication_S0000006000)
	LDI  R27,HIGH(_time_lubrication_S0000006000)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 0191     if(time_lubrication>600)
	LDS  R26,_time_lubrication_S0000006000
	LDS  R27,_time_lubrication_S0000006000+1
	CPI  R26,LOW(0x259)
	LDI  R30,HIGH(0x259)
	CPC  R27,R30
	BRLT _0x8D
; 0000 0192         time_lubrication = 0;
	LDI  R30,LOW(0)
	STS  _time_lubrication_S0000006000,R30
	STS  _time_lubrication_S0000006000+1,R30
; 0000 0193 
; 0000 0194     if(time_lubrication>=0 && time_lubrication<30){//lubrication
_0x8D:
	LDS  R26,_time_lubrication_S0000006000+1
	TST  R26
	BRMI _0x8F
	LDS  R26,_time_lubrication_S0000006000
	LDS  R27,_time_lubrication_S0000006000+1
	SBIW R26,30
	BRLT _0x90
_0x8F:
	RJMP _0x8E
_0x90:
; 0000 0195         if(KA9_ON){
	SBIC 0x13,3
	RJMP _0x91
; 0000 0196             KAR32_ON
	LDI  R30,LOW(1)
	OR   R6,R30
; 0000 0197         }else {
	RJMP _0x92
_0x91:
; 0000 0198             KAR32_OFF
	LDI  R30,LOW(254)
	AND  R6,R30
; 0000 0199         }
_0x92:
; 0000 019A     }
; 0000 019B }
_0x8E:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	RETI
;//------------------------------------------------------
;//
;//------------------------------------------------------
;void timer_on(void)
; 0000 01A0 {
_timer_on:
; 0000 01A1     time = 0;
	CLR  R4
	CLR  R5
; 0000 01A2     TCCR1A=0x00;
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0000 01A3     TCCR1B=0x04;
	LDI  R30,LOW(4)
	RJMP _0x2020001
; 0000 01A4     TCNT1H=0x00;
; 0000 01A5     TCNT1L=0x00;
; 0000 01A6 }
;//------------------------------------------------------
;//
;//------------------------------------------------------
;void timer_off(void)
; 0000 01AB {
_timer_off:
; 0000 01AC     time = 0;
	CLR  R4
	CLR  R5
; 0000 01AD     TCCR1A=0x00;
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0000 01AE     TCCR1B=0x00;
_0x2020001:
	OUT  0x2E,R30
; 0000 01AF     TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 01B0     TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 01B1 }
	RET
;//------------------------------------------------------
;//
;//------------------------------------------------------
;void init(void){
; 0000 01B5 void init(void){
_init:
; 0000 01B6 
; 0000 01B7 PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 01B8 DDRA=0x00;
	OUT  0x1A,R30
; 0000 01B9 
; 0000 01BA PORTB=0b00000000;
	OUT  0x18,R30
; 0000 01BB DDRB=0b01110111;
	LDI  R30,LOW(119)
	OUT  0x17,R30
; 0000 01BC 
; 0000 01BD PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 01BE DDRC=0x00;
	OUT  0x14,R30
; 0000 01BF 
; 0000 01C0 PORTD=0x00;
	OUT  0x12,R30
; 0000 01C1 DDRD=0x00;
	OUT  0x11,R30
; 0000 01C2 
; 0000 01C3 PORTE=0x00;
	OUT  0x3,R30
; 0000 01C4 DDRE=0x00;
	OUT  0x2,R30
; 0000 01C5 
; 0000 01C6 PORTF=0b11111111;
	LDI  R30,LOW(255)
	STS  98,R30
; 0000 01C7 DDRF=0x00;
	LDI  R30,LOW(0)
	STS  97,R30
; 0000 01C8 
; 0000 01C9 // Port G initialization
; 0000 01CA // Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 01CB // State4=T State3=T State2=T State1=T State0=T
; 0000 01CC PORTG=0b11111;
	LDI  R30,LOW(31)
	STS  101,R30
; 0000 01CD DDRG=0x00;
	LDI  R30,LOW(0)
	STS  100,R30
; 0000 01CE 
; 0000 01CF // Timer/Counter 0 initialization
; 0000 01D0 // Clock source: System Clock
; 0000 01D1 // Clock value: Timer 0 Stopped
; 0000 01D2 // Mode: Normal top=0xFF
; 0000 01D3 // OC0 output: Disconnected
; 0000 01D4 ASSR=0x00;
	OUT  0x30,R30
; 0000 01D5 TCCR0=0x00;
	OUT  0x33,R30
; 0000 01D6 TCNT0=0x00;
	OUT  0x32,R30
; 0000 01D7 OCR0=0x00;
	OUT  0x31,R30
; 0000 01D8 
; 0000 01D9 // Timer/Counter 1 initialization
; 0000 01DA // Clock source: System Clock
; 0000 01DB // Clock value: Timer1 Stopped
; 0000 01DC // Mode: Normal top=0xFFFF
; 0000 01DD // OC1A output: Discon.
; 0000 01DE // OC1B output: Discon.
; 0000 01DF // OC1C output: Discon.
; 0000 01E0 // Noise Canceler: Off
; 0000 01E1 // Input Capture on Falling Edge
; 0000 01E2 // Timer1 Overflow Interrupt: Off
; 0000 01E3 // Input Capture Interrupt: Off
; 0000 01E4 // Compare A Match Interrupt: Off
; 0000 01E5 // Compare B Match Interrupt: Off
; 0000 01E6 // Compare C Match Interrupt: Off
; 0000 01E7 TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 01E8 TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 01E9 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 01EA TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 01EB ICR1H=0x00;
	OUT  0x27,R30
; 0000 01EC ICR1L=0x00;
	OUT  0x26,R30
; 0000 01ED OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 01EE OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 01EF OCR1BH=0x00;
	OUT  0x29,R30
; 0000 01F0 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 01F1 OCR1CH=0x00;
	STS  121,R30
; 0000 01F2 OCR1CL=0x00;
	STS  120,R30
; 0000 01F3 
; 0000 01F4 // Timer/Counter 2 initialization
; 0000 01F5 // Clock source: System Clock
; 0000 01F6 // Clock value: Timer2 Stopped
; 0000 01F7 // Mode: Normal top=0xFF
; 0000 01F8 // OC2 output: Disconnected
; 0000 01F9 TCCR2=0x00;
	OUT  0x25,R30
; 0000 01FA TCNT2=0x00;
	OUT  0x24,R30
; 0000 01FB OCR2=0x00;
	OUT  0x23,R30
; 0000 01FC 
; 0000 01FD // Timer/Counter 3 initialization
; 0000 01FE // Clock source: System Clock
; 0000 01FF // Clock value: Timer3 Stopped
; 0000 0200 // Mode: Normal top=0xFFFF
; 0000 0201 // OC3A output: Discon.
; 0000 0202 // OC3B output: Discon.
; 0000 0203 // OC3C output: Discon.
; 0000 0204 // Noise Canceler: Off
; 0000 0205 // Input Capture on Falling Edge
; 0000 0206 // Timer3 Overflow Interrupt: Off
; 0000 0207 // Input Capture Interrupt: Off
; 0000 0208 // Compare A Match Interrupt: Off
; 0000 0209 // Compare B Match Interrupt: Off
; 0000 020A // Compare C Match Interrupt: Off
; 0000 020B TCCR3A=0x00;
	STS  139,R30
; 0000 020C TCCR3B=0x04;
	LDI  R30,LOW(4)
	STS  138,R30
; 0000 020D TCNT3H=0x00;
	LDI  R30,LOW(0)
	STS  137,R30
; 0000 020E TCNT3L=0x00;
	STS  136,R30
; 0000 020F ICR3H=0x00;
	STS  129,R30
; 0000 0210 ICR3L=0x00;
	STS  128,R30
; 0000 0211 OCR3AH=0x00;
	STS  135,R30
; 0000 0212 OCR3AL=0x00;
	STS  134,R30
; 0000 0213 OCR3BH=0x00;
	STS  133,R30
; 0000 0214 OCR3BL=0x00;
	STS  132,R30
; 0000 0215 OCR3CH=0x00;
	STS  131,R30
; 0000 0216 OCR3CL=0x00;
	STS  130,R30
; 0000 0217 
; 0000 0218 // External Interrupt(s) initialization
; 0000 0219 // INT0: Off
; 0000 021A // INT1: Off
; 0000 021B // INT2: Off
; 0000 021C // INT3: Off
; 0000 021D // INT4: Off
; 0000 021E // INT5: Off
; 0000 021F // INT6: Off
; 0000 0220 // INT7: Off
; 0000 0221 EICRA=0x00;
	STS  106,R30
; 0000 0222 EICRB=0x00;
	OUT  0x3A,R30
; 0000 0223 EIMSK=0x00;
	OUT  0x39,R30
; 0000 0224 
; 0000 0225 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0226 TIMSK=0x04;
	LDI  R30,LOW(4)
	OUT  0x37,R30
; 0000 0227 
; 0000 0228 ETIMSK=0x04;
	STS  125,R30
; 0000 0229 
; 0000 022A // USART0 initialization
; 0000 022B // USART0 disabled
; 0000 022C UCSR0B=0x00;
	LDI  R30,LOW(0)
	OUT  0xA,R30
; 0000 022D 
; 0000 022E // USART1 initialization
; 0000 022F // USART1 disabled
; 0000 0230 UCSR1B=0x00;
	STS  154,R30
; 0000 0231 
; 0000 0232 // Analog Comparator initialization
; 0000 0233 // Analog Comparator: Off
; 0000 0234 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 0235 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0236 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 0237 
; 0000 0238 // ADC initialization
; 0000 0239 // ADC disabled
; 0000 023A ADCSRA=0x00;
	OUT  0x6,R30
; 0000 023B 
; 0000 023C // SPI initialization
; 0000 023D // SPI Type: Master
; 0000 023E // SPI Clock Rate: 125,000 kHz
; 0000 023F // SPI Clock Phase: Cycle Start
; 0000 0240 // SPI Clock Polarity: High
; 0000 0241 // SPI Data Order: MSB First
; 0000 0242 SPCR=0x53;//5B
	LDI  R30,LOW(83)
	OUT  0xD,R30
; 0000 0243 SPSR=0x00;
	LDI  R30,LOW(0)
	OUT  0xE,R30
; 0000 0244 
; 0000 0245 // TWI initialization
; 0000 0246 // TWI disabled
; 0000 0247 TWCR=0x00;
	STS  116,R30
; 0000 0248 #asm("sei")
	sei
; 0000 0249 }
	RET
;//------------------------------------------------------
;//
;//------------------------------------------------------
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG

	.DSEG
_M_S0000001000:
	.BYTE 0x2
_T_S0000001000:
	.BYTE 0x2
_KOD_S0000001000:
	.BYTE 0x2
_first_S0000003000:
	.BYTE 0x1
_second_S0000003000:
	.BYTE 0x1
_third_S0000003000:
	.BYTE 0x1
_fourth_S0000003000:
	.BYTE 0x1
_time_lubrication_S0000006000:
	.BYTE 0x2

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0x0:
	ST   -Y,R7
	ST   -Y,R6
	ST   -Y,R9
	MOV  R26,R8
	RJMP _out

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(251)
	AND  R6,R30
	LDI  R30,LOW(253)
	AND  R6,R30
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2:
	LDS  R26,_T_S0000001000
	LDS  R27,_T_S0000001000+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	CP   R4,R30
	CPC  R5,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4:
	OR   R6,R30
	LDI  R30,LOW(1)
	OR   R7,R30
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x5:
	CALL __EQB12
	MOV  R0,R30
	LDI  R26,0
	SBIC 0x13,0
	LDI  R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(0)
	CALL __EQB12
	OR   R0,R30
	LDI  R26,0
	SBIC 0x13,5
	LDI  R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	LDI  R26,0
	SBIC 0x13,1
	LDI  R26,1
	LDI  R30,LOW(0)
	RJMP SUBOPT_0x5


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xFA0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__LSLW3:
	LSL  R30
	ROL  R31
__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__EQB12:
	CP   R30,R26
	LDI  R30,1
	BREQ __EQB12T
	CLR  R30
__EQB12T:
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
