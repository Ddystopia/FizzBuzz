%macro try 2

  mov ax, cx
  mov bh, %1
  div bh
  cmp ah, 0
  jne after_%2
  call %2
  after_%2: 

%endmacro

section .data
  fizz_msg dd "fizz"
  buzz_msg dd "buzz"

section .bss
  msg resb 9

section .text
  global _start

_start:
  mov ecx, 1
l1:
  try 3, fizz
  try 5, buzz

  cmp [msg], byte 0
  jne show_word
  call convert_num

  show_word:
  mov [msg + 8], byte 10
  push ecx
  mov eax, 4
  mov ebx, 1
  mov ecx, msg
  mov edx, 9
  int 80h
  pop ecx

  iter_end:
  mov [msg], dword 0
  mov [msg+4], dword 0
  mov [msg+8], dword 0
  inc cx
  cmp cx, 100
  jle l1

exit:
  mov eax, 1
  xor ebx, ebx
  int 80h

convert_num:
  mov ax, cx
  mov bl, 10
  xor esi, esi
  xor edx, edx
  push -1
convert_iter:
  div bl
  mov dl, ah
  add dl, '0'
  push dx 
  xor ah, ah
  cmp ax, 0
  jne convert_iter
write_iter:
  pop ax
  cmp ax, -1
  je write_iter_end
  mov [msg+esi], ax
  inc esi
  jmp write_iter
  write_iter_end:
  pop ax
  ret

fizz:
  mov eax, [fizz_msg]
  mov [msg], dword eax
  ret

buzz:
  mov eax, [buzz_msg]
  mov ebx, msg
  cmp [ebx], dword 0
  je after_add
  add ebx, 4
  after_add:
  mov [ebx], dword eax
  ret

