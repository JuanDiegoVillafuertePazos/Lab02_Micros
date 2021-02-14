;Archivo:	principa.s
;Dispositivo:	    PIC16F887
;Autor:	    Juan Diego Villafuerte
;Compilador: pic-as (v2.30), MPLABX V5.40
;
;Programa:	Contador en el pueto A
;Hardware:	LEDs en el puerto A
;
;Creado;	1 febrero 2021
;Última modificación:	    1 febrero 2021

PROCESSOR 16F887
#include <xc.inc>
    ;configuration word 1

    CONFIG FOSC=INTRC_NOCLKOUT // Osilador interno sin salida
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
	cont_small: DS 1 ;1 byte
	cont_big: DS 1
    PSECT resVect, class=CODE, abs, delta=2
    OrG 00h	;posición 0000h para el reset
resetVec:
	PAGESEL principa
	goto principa
    
    PSECT code, delta=2, abs
    ORG 100h
    
principa:
    bsf	    STATUS, 5
    bsf	    STATUS, 6
    clrf    ANSEL
    clrf    ANSELH
    
    bsf	    STATUS, 5
    bcf	    STATUS, 6
    clrf    TRISA
    
    bcf	    STATUS, 5
    bcf	    STATUS, 6
    
;***********loop principal**************
loop:
    incf    PORTA, 1
    call    delay_big
    goto    loop
;***********subrutina de delay**********
delay_big:
    movlw   199
    movwf   cont_big
    call    delay_small
    decfsz  cont_big, 1
    goto    $-2
    return
    
delay_small:
    movlw   250
    movwf   cont_small
    decfsz  cont_small, 1
    goto    $-1
    return
end