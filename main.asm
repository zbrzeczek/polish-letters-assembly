; wczytywanie i wyœwietlanie tekstu wielkimi literami
; (inne znaki siê nie zmieniaj¹)
.686
.model flat
extern _ExitProcess@4 : PROC
extern __write : PROC ; (dwa znaki podkreœlenia)
extern __read : PROC ; (dwa znaki podkreœlenia)

public _main

.data
	tekst_pocz db 10, 'Proszê napisaæ jakiœ tekst '
	db 'i nacisnac Enter', 10

	koniec_t db ?
	magazyn db 80 dup (?)
	output db 80 dup (?)
	nowa_linia db 10
	liczba_znakow dd ?

.code
_main PROC

	; wyœwietlenie tekstu informacyjnego
	 mov ecx,(OFFSET koniec_t) - (OFFSET tekst_pocz) ; liczba znaków tekstu
	 push ecx
	 push OFFSET tekst_pocz ; adres tekstu
	 push 1 ; nr urz¹dzenia (tu: ekran - nr 1)
	 call __write ; wyœwietlenie tekstu pocz¹tkowego

	 add esp, 12 ; usuniecie parametrów ze stosu

	; czytanie wiersza z klawiatury

	 push 80 ; maksymalna liczba znaków
	 push OFFSET magazyn
	 push 0 ; nr urz¹dzenia (tu: klawiatura - nr 0)
	 call __read ; czytanie znaków z klawiatury
	 add esp, 12 ; usuniecie parametrów ze stosu

	; kody ASCII napisanego tekstu zosta³y wprowadzone
	; do obszaru 'magazyn'
	; funkcja read wpisuje do rejestru EAX liczbê
	; wprowadzonych znaków
	 mov liczba_znakow, eax

	; rejestr ECX pe³ni rolê licznika obiegów pêtli
	 mov ecx, eax
	 mov bh, 0 ; indeks pocz¹tkowy
	 mov bl, 0 ; indeks outputu
ptl: 
	 mov dl, magazyn[ebx] ; pobranie kolejnego znaku
	 cmp dl, '/'
	 je dalej ; skok, gdy znak nie wymaga zamiany

	 mov output[ebx], dl
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

	mov magazyn[ebx], dl

zmianaA:
	mov output[ebx]	

zmianaE:

zmianaZ:

koniec:
	
	inc ebx ; inkrementacja indeksu


	loop ptl ; sterowanie pêtl¹

	
	 push 4
	 push liczba_znakow
	 push OFFSET magazyn
	 push 0
	 
	 call _MessageBoxA@16 ; wyœwietlenie przekszta³conego tekstu
	 
	 add esp, 12 ; usuniecie parametrów ze stosu


	 push 0
	 call _ExitProcess@4 ; zakoñczenie programu

_main ENDP
END