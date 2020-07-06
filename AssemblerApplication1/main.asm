;
; Signalisation_Amar.asm
;
; Created: 12/04/2020 14:54:18
; Author : Amar
;

.include "./m328Pdef.inc"

; PORTS D'ENTREES/SORTIES 
; Port A0  Branché sur une LED 
; A1 à A7 Libre 
; Port B0 à B7 Libre 
; Port C0 à C7  Libre 
; Port D0 à D7 Libre 
 

 ;   DEFINITIONS DE REGISTRES 
 ; r0 à r15 Libre 
 ; r16 à r20 Utilisé par le programme 
 ; r21 à r25 Libre 
 ; r26 à r31 Réservé pour registre X, Y, Z

 .DSEG 
 .ORG $100 ; début de la mémoire disponible pour l’utilisateur 
 ;Ici on peut définir des variables locales d’un octet pour stocker des valeurs quelconques. 

 ;Interruptions non utilisées
EXT_INT0: ;IRQ0
EXT_INT1: ;IRQ1
EXT_INT2: ;IRQ2
TIM2_COMP: ;Timer2 Comparaison
TIM2_OVF: ;Timer2 Overflow
TIM1_CAPT: ;Timer1 Capture
TIM1_COMPA: ;Timer1 CompareA
TIM1_COMPB: ;Timer1 CompareB
TIM1_OVF: ;Timer1 Overflow
TIM0_COMP: ;Timer0 Compare
TIM0_OVF: ;Timer0 Overflow
SPI_STC: ;SPI Transfer Complete
USART_RXC: ;USART RX Complete
USART_UDRE: ;UDR Empty
USART_TXC: ;USART TX Complete
EE_RDY: ;EEPROM Ready
ADC_COMP: ;ADC Conversion Complète
ANA_COMP: ;Analog Comparator
TWI: ;Two-wire Serial Interface
SPM_RDY: ;Store Program Memory Ready
  
 .CSEG		 ;Segment de Code 
 .ORG  $0000   ;Positionnement au début de la mémoire  
.CSEG							
.org  0						
  jmp   Initialisation     
.org INT0addr					
  jmp Bouton

Initialisation:

	ldi r22,0b00010010		; Initialisation des éléments au passage au rouge	
	ldi r23,0b00001010		; Initialisation des éléments au passage à l'orange
	ldi r24,0b00000110		; Initialisation des éléments au passage à vert	
	ldi r25,0b00010001		; Initialisation des éléments à l'appui du bouton

	ldi r16,0b00000000			
	out DDRB,r16			
	ldi   r16,0b00000000	
	out   DDRD,r16			
	sbi   PORTD,2	
	sbi   EIMSK, INT0			
	ldi   r16, (1<<ISC01)		
	sts   EICRA, r16 
	sei							


		
Boucle:							

		out DDRB,r24
		out PortB,r24			; feu verte 5s
			ldi  r18, 2
			ldi  r19, 252
			ldi  r20, 77
			ldi  r21, 205
		L1: dec  r21
			brne L1
			dec  r20
			brne L1
			dec  r19
			brne L1
			dec  r18
			brne L1
		out DDRB,r23
		out PortB,r23			; feu orange 2s
			ldi  r18, 203
			ldi  r19, 236
			ldi  r20, 133
		L2: dec  r20
			brne L2
			dec  r19
			brne L2
			dec  r18
			brne L2
			nop
		out DDRB,r22
		out PortB,r22			; feu rouge 5s
			ldi  r18, 2
			ldi  r19, 252
			ldi  r20, 77
			ldi  r21, 205
		L3: dec  r21
			brne L3
			dec  r20
			brne L3
			dec  r19
			brne L3
			dec  r18
			brne L3
		cpi    r17, 0			

		clr  r17			
		rjmp Boucle				; Retour au début de la boucle du feu


Bouton:
		out DDRB,r25
		out PortB,r25			; feu rouge 5s, pieton vert pendant 5s
			ldi  r18, 2
			ldi  r19, 252
			ldi  r20, 77
			ldi  r21, 205
		L4: dec  r21
			brne L4
			dec  r20
			brne L4
			dec  r19
			brne L4
			dec  r18
			brne L4
		ser r17			
		rjmp Initialisation ; retour à l'initialisation après les instructions due au bouton

