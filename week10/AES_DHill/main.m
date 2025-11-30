% Main file to encrypt and decrypt using AES-128/192/256
% Example run:
% key = '000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f'
% In = '00112233445566778899aabbccddeeff'
% Out = Cipher(key, In)
% InvCipher(key, Out)

clc;
clear;

% Example input values
key = '000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f';
In = '00112233445566778899aabbccddeeff';

% Encrypt the input using AES
disp('Original input:');
disp(In);

Out = Cipher(key, In);
disp('Encrypted output:');
disp(Out);

% Decrypt the encrypted output
decipheredText = InvCipher(key, Out);
disp('Decrypted output:');
disp(decipheredText);

