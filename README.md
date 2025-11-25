# Cryptography Lab Exercises

This repository contains a collection of cryptographic algorithm implementations and lab exercises, primarily written in MATLAB, covering various topics from classical ciphers to modern public-key cryptography.

## Project Structure

The project is organized by weeks, each focusing on specific cryptographic concepts:

### Week 5: Classical Ciphers
- **Caesar Cipher**: Implementation of the substitution cipher (`caeser.m`).
- **One Time Pad**: Implementation of the perfect secrecy cipher (`oneTimePad.m`).

### Week 6: Block & Stream Ciphers
- **AES (Advanced Encryption Standard)**:
  - Implementation of AES-128, 192, 256.
  - Includes `Cipher` (encrypt), `InvCipher` (decrypt), and key expansion logic.
  - *Reference*: David Hill (2022). Advanced Encryption Standard (AES)-128,192, 256.
- **DES (Data Encryption Standard)**:
  - Implementation of DES algorithm and key generation.
- **RC4**:
  - Implementation of the RC4 stream cipher (KSA and PRGA phases).
- **XOR Cipher**: Simple XOR encryption example.

### Week 7: Hashing & MAC
- **HMAC**:
  - Implementation of Keyed-Hashing for Message Authentication.
  - Includes `DataHash.m` utility.

### Week 8: Public Key Cryptography
- **Diffie-Hellman**:
  - Key exchange implementation (`DHKey.m`) and a Python version (`DHKeyPy.py`).
- **RSA**:
  - Multiple implementations of RSA encryption/decryption and digital signatures.
  - **RSA_32**: Includes key generation, modular exponentiation, sign/verify, and extended Euclidean algorithm.
  - **VoiceEncryptRSA**: A demonstration of encrypting voice data using RSA.

## Prerequisites

- **MATLAB**: Most scripts are `.m` files requiring a MATLAB environment.
- **Python**: Some auxiliary scripts (e.g., in `week8`) may require Python.

## Usage

Most directories contain a `main_script.m` or specific function files that can be run directly in MATLAB.

Example for AES (Week 6):
1. Open MATLAB.
2. Navigate to `week6/AESBlockCipher/`.
3. Run `main_script.m`.

## Citations & References

This collection includes code adapted from MATLAB Central File Exchange contributions:
- **AES**: David Hill (2022). [Advanced Encryption Standard (AES)-128,192, 256](https://www.mathworks.com/matlabcentral/fileexchange/73412-advanced-encryption-standard-aes-128-192-256).
- **RSA**: Shaun Gomez (2022). [Implementation of RSA Algorithm](https://www.mathworks.com/matlabcentral/fileexchange/38439-implementation-of-rsa-algorithm).
- **RSA**: suriyanath (2022). [RSA algorithm](https://www.mathworks.com/matlabcentral/fileexchange/46824-rsa-algorithm).

