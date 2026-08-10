import base64
from Cryptodome.Cipher import AES
from Cryptodome.Util.Padding import pad

plaintext = b"mulyono123"
target_b64 = "HofYsqD30i7bRT8NGi2i+A=="
target_bytes = base64.b64decode(target_b64)

def check_keys():
    with open("swf_strings.txt", "r", encoding="utf-8") as f:
        strings = f.read().splitlines()

    for s in strings:
        # Key must be 16, 24, or 32 bytes for AES
        for key_len in [16, 24, 32]:
            if len(s) >= key_len:
                # Try prefix of the string as key
                key = s[:key_len].encode('ascii', errors='ignore')
                if len(key) != key_len:
                    continue
                
                # Try ECB
                try:
                    cipher = AES.new(key, AES.MODE_ECB)
                    padded = pad(plaintext, AES.block_size)
                    encrypted = cipher.encrypt(padded)
                    if encrypted == target_bytes:
                        print(f"FOUND ECB KEY: {key}")
                        return
                except Exception:
                    pass
                
                # Try CBC with zero IV
                try:
                    cipher = AES.new(key, AES.MODE_CBC, iv=b'\x00'*16)
                    padded = pad(plaintext, AES.block_size)
                    encrypted = cipher.encrypt(padded)
                    if encrypted == target_bytes:
                        print(f"FOUND CBC KEY (Zero IV): {key}")
                        return
                except Exception:
                    pass
                    
                # Try CBC with key as IV (if key is 16 bytes)
                if key_len == 16:
                    try:
                        cipher = AES.new(key, AES.MODE_CBC, iv=key)
                        padded = pad(plaintext, AES.block_size)
                        encrypted = cipher.encrypt(padded)
                        if encrypted == target_bytes:
                            print(f"FOUND CBC KEY (Key IV): {key}")
                            return
                    except Exception:
                        pass
                        
    print("Key not found in extracted strings.")

if __name__ == "__main__":
    check_keys()
