; wczytywanie i wyœwietlanie tekstu wielkimi literami
; (inne znaki siê nie zmieniaj¹)
.686
.model flat
extern _ExitProcess@4 : PROC
extern _MessageBoxA@16 : PROC
extern __write : PROC ; (dwa znaki podkreœlenia)
extern __read : PROC ; (dwa znaki podkreœlenia)

public _main

.data
	tekst_pocz db 10, 'Proszê napisaæ jakiœ tekst '
	db 'i nacisnac Enter', 10
	tytulW 		dd  00790050h,0h

	koniec_t db ?
	magazyn db 80 dup (?)
	output db 80 dup (?)
	nowa_linia db 10
	liczba_znakow dd ?

.code
_main PROC

	; czytanie wiersza z klawiatury
	 push 80 ; maksymalna liczba znaków
	 push OFFSET magazyn
	 push 0 ; nr urz¹dzenia (tu: klawiatura - nr 0)
	 call __read ; czytanie znaków z klawiatury
	 add esp, 12 ; usuniecie parametrów ze stosu


	; funkcja read wpisuje do rejestru EAX liczbê
	; wprowadzonych znaków
	 mov liczba_znakow, eax

	; rejestr ECX pe³ni rolê licznika obiegów pêtli
	 mov ecx, eax
	 mov ebx, 0 ; indeks pocz¹tkowy magazynu
	 mov eax, 0 ; indeks outputu


ptl: 
	 mov dl, magazyn[ebx] ; pobranie kolejnego znaku
	 cmp dl, '/'
	 je dalej ; skok, gdy znak nie wymaga zamiany

	 mov output[eax], dl
	jmp koniec

dalej:
	inc ebx ; inkrementacja indeksu
	mov dl, magazyn[ebx]
	cmp dl, 'a'
	je zmianaA

	cmp dl, 'e'
	je zmianaE

	cmp dl, 'z'
	je zmianaZ

zmianaA:
	mov output[eax], 185
	inc eax
	jmp koniec

zmianaE:
	mov output[eax], 'ê'
	inc eax
	jmp koniec

zmianaZ:
	mov output[eax], '¿'
	inc eax
	jmp koniec

koniec:
	inc ebx
	inc eax ; inkrementacja indeksu

	loop ptl ; sterowanie pêtl¹


	push  4   ; utype
	push OFFSET tytulW
	push OFFSET output
	push  0 ; hwnd
	call _MessageBoxA@16


	push 0  ; exit code
	call _ExitProcess@4

_main ENDP
END