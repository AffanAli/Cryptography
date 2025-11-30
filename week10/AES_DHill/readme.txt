How to use!
Cipher is to encrypt
InvCipher is to decrypt

Example run:

>> key='000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f'

key =

    '000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f'

>> In='00112233445566778899aabbccddeeff'

In =

    '00112233445566778899aabbccddeeff'

>> Out = Cipher(key,In)

Out =

    '8ea2b7ca516745bfeafc49904b496089'

>> In='8ea2b7ca516745bfeafc49904b496089'

In =

    '8ea2b7ca516745bfeafc49904b496089'

>> InvCipher(key, In)

ans =

    '00112233445566778899aabbccddeeff'

>> 

Overview:
AES-128/192/256 algorithm for creating a cipher given a 128-bit hexadecimal input message 
and 128/192/256-bit hexadecimal key. Created using FIBS-197 standard. Algorithm was not built 
for speed and does not covert a text message or data input 128-bit input blocks. Cipher and 
InvCipher are the main functions to execute. Function executes AES128 or AES192 or AES256 based 
on the key size. Functions do not check whether the key size or input are the correct length 
and will error if they are not the correct size.

Example:
Out = Cipher(key,In)
%key='000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f'
%In='00112233445566778899aabbccddeeff'
%Out='8ea2b7ca516745bfeafc49904b496089'

Out=InvCipher(key,In)
%key='000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f'
%In='8ea2b7ca516745bfeafc49904b496089'
%Out='00112233445566778899aabbccddeeff'

Cite As
David Hill (2022). Advanced Encryption Standard (AES)-128,192, 256 (https://www.mathworks.com/matlabcentral/fileexchange/73412-advanced-encryption-standard-aes-128-192-256), MATLAB Central File Exchange. Retrieved June 28, 2022.