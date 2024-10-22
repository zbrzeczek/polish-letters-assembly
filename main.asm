; wczytywanie i wy�wietlanie tekstu wielkimi literami
; (inne znaki si� nie zmieniaj�)
.686
.model flat
extern _ExitProcess@4 : PROC
extern __write : PROC ; (dwa znaki podkre�lenia)
extern __read : PROC ; (dwa znaki podkre�lenia)

public _main

.data
	tekst_pocz db 10, 'Prosz� napisa� jaki� tekst '
	db 'i nacisnac Enter', 10

	koniec_t db ?
	magazyn db 80 dup (?)
	output db 80 dup (?)
	nowa_linia db 10
	liczba_znakow dd ?

.code
_main PROC

	; wy�wietlenie tekstu informacyjnego
	 mov ecx,(OFFSET koniec_t) - (OFFSET tekst_pocz) ; liczba znak�w tekstu
	 push ecx
	 push OFFSET tekst_pocz ; adres tekstu
	 push 1 ; nr urz�dzenia (tu: ekran - nr 1)
	 call __write ; wy�wietlenie tekstu pocz�tkowego

	 add esp, 12 ; usuniecie parametr�w ze stosu

	; czytanie wiersza z klawiatury

	 push 80 ; maksymalna liczba znak�w
	 push OFFSET magazyn
	 push 0 ; nr urz�dzenia (tu: klawiatura - nr 0)
	 call __read ; czytanie znak�w z klawiatury
	 add esp, 12 ; usuniecie parametr�w ze stosu

	; kody ASCII napisanego tekstu zosta�y wprowadzone
	; do obszaru 'magazyn'
	; funkcja read wpisuje do rejestru EAX liczb�
	; wprowadzonych znak�w
	 mov liczba_znakow, eax

	; rejestr ECX pe�ni rol� licznika obieg�w p�tli
	 mov ecx, eax
	 mov bh, 0 ; indeks pocz�tkowy
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


	loop ptl ; sterowanie p�tl�

	
	 push 4
	 push liczba_znakow
	 push OFFSET magazyn
	 push 0
	 
	 call _MessageBoxA@16 ; wy�wietlenie przekszta�conego tekstu
	 
	 add esp, 12 ; usuniecie parametr�w ze stosu


	 push 0
	 call _ExitProcess@4 ; zako�czenie programu

_main ENDP
END