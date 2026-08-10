import zlib
import re

swf_path = r"C:\Users\acer\Downloads\NinjaSage\NinjaSage.swf"

def extract_strings():
    with open(swf_path, 'rb') as f:
        data = f.read()
        
    signature = data[:3]
    if signature == b'CWS':
        body = zlib.decompress(data[8:])
    else:
        body = data[8:]
        
    # Extract all printable ASCII strings length >= 16 (since AES key is 16, 24, or 32 bytes)
    strings = re.findall(b'[ -~]{16,}', body)
    
    # Save to a file for manual inspection or scripted brute forcing
    with open("swf_strings.txt", "w", encoding="utf-8") as out:
        for s in set(strings):
            out.write(s.decode('ascii', errors='ignore') + "\n")
            
    print(f"Extracted {len(set(strings))} unique strings of length >= 16.")

if __name__ == "__main__":
    extract_strings()
