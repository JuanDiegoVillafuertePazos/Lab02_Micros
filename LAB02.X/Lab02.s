;Archivo:	Segundo.s
;Dispositivo:	    PIC16F887
;Autor:	    Juan Diego Villafuerte
;Compilador: pic-as (v2.30), MPLABX V5.40
;
;Programa:	Contador manual y sumador con respuesta de carry
;Hardware:	LEDs en puestos C y D, botones en puerto B
;
;Creado;	9 febrero 2021
;Última modificación:	    1 febrero 2021

PROCESSOR 16F887
#include <xc.inc>
    ;configuration word 1

    CONFIG FOSC=XT // Osilador externo
    CONFIG WDTE=OFF // WDT disabled (reinicio repetitivo del pic)
    CONFIG PWRTE=ON // PWRT eneable (espeera de 72ms al inicial)
    CONFIG MCLRE=OFF // El pin de MCLR se utiliza como I/O 
    CONFIG CP=OFF // Sin protección de código
    CONFIG CPD=OFF // Sin protección de datos
    
    CONFIG BOREN=OFF //Sin reinicio cuándo el voltaje de alimentación baja de 4V
    CONFIG IESO=OFF // Reinicio sin cambio de reloj de interno a externo
    CONFIG FCMEN=OFF // Cambio de reloj externo a interno en caso de fallo
    CONFIG LVP=ON // Programación en bajo voltaje permitida
    
    ;configuration word 2
    
    CONFIG WRT=OFF // Protección de autoescritura por el programa desactivada
    CONFIG BOR4V=BOR40V // Reinicio abajo de 4V1 (BOR21V=2.1V)
    
    PSECT udata_bank0 ;common memory
	;inc_cont_1: DS 1 ;1 byte
	;var: DS 5
;_____________________________Para el vector reset______________________________   
    PSECT resVect, class=CODE, abs, delta=2
    OrG 00h	;posición 0000h para el reset
resetVec:
	PAGESEL Segundo
	goto Segundo
    
    PSECT code, delta=2, abs
    ORG 100h
    
;________________________________Loop del codigo________________________________   

Segundo:
    banksel ANSEL  ;Movernos al banco 3
    clrf ANSEL     ;Para que sean digitales
    clrf ANSELH
    
    banksel TRISB  ;Movernos al banco 1
    bsf TRISB,0	   ;Puertos B como inputs
    bsf TRISB,1
    bsf TRISB,2
    bsf TRISB,3
    bsf TRISB,4
    clrf TRISC	   ;Puertos C como outputs
    clrf TRISD	   ;Puertos D como outputs
    clrf TRISA	   ;Puertos A como outputs
    
    bsf TRISC,4
    bsf TRISC,5
    bsf TRISC,6
    bsf TRISC,7
    bsf TRISA,4
    bsf TRISA,5
    bsf TRISA,6
    bsf TRISA,7
    
    banksel PORTA  ;Movernos al banco 0
    clrf PORTB	   ;Para que comiencen en 0
    clrf PORTC
    clrf PORTD
    clrf PORTA

PrimerContador:
    banksel PORTA
    btfsc PORTB,0
    call inc_cont_1
    btfsc PORTB,1
    call dec_cont_1
    
    btfsc PORTB,2
    call inc_cont_2
    btfsc PORTB,3
    call dec_cont_2
    
    btfsc PORTB,4
    call add_w_puerto
    
    btfsc PORTD,4
    call carry
    
    goto PrimerContador
    
inc_cont_1:
    btfsc PORTB,0
    goto $-1
    incf PORTC
    return
    
dec_cont_1:
    btfsc PORTB,1
    goto $-1
    decf PORTC
    return

inc_cont_2:
    btfsc PORTB,2
    goto $-1
    incf PORTA
    return
    
dec_cont_2:
    btfsc PORTB,3
    goto $-1
    decf PORTA
    return
   
add_w_puerto:
    btfsc PORTB,4
    goto $-1
    movf PORTA,W
    addwf PORTC,W
    movwf PORTD
    return
 
carry:
    btfss PORTD,4
    goto $-1
    bsf PORTD,7
    return
end


