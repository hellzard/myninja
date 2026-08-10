import os
import zlib
import shutil

swf_path = r"C:\Users\acer\Downloads\NinjaSage\NinjaSage.swf"
backup_path = r"C:\Users\acer\Downloads\NinjaSage\NinjaSage.swf.bak"

def patch_swf():
    print(f"Reading {swf_path}...")
    
    if not os.path.exists(backup_path):
        print(f"Creating backup at {backup_path}")
        shutil.copy2(swf_path, backup_path)
    
    print("Using backup to ensure clean patch...")
    shutil.copy2(backup_path, swf_path)
        
    with open(swf_path, 'rb') as f:
        data = f.read()
        
    signature = data[:3]
    version = data[3:4]
    
    if signature == b'CWS':
        print("Decompressing SWF...")
        uncompressed_body = zlib.decompress(data[8:])
    elif signature == b'FWS':
        uncompressed_body = data[8:]
    else:
        print("Unsupported SWF format.")
        return

    # Patch 1: play.ninjasage.id
    url1_orig = b"https://play.ninjasage.id"
    url1_new = b"http://127.0.0.1:800/play"
    if url1_orig in uncompressed_body:
        uncompressed_body = uncompressed_body.replace(url1_orig, url1_new)
        print(f"Patched '{url1_orig.decode()}' -> '{url1_new.decode()}'")
        
    # Patch 2: ninjasage.id
    url2_orig = b"https://ninjasage.id"
    url2_new = b"http://127.0.0.1:800"
    if url2_orig in uncompressed_body:
        uncompressed_body = uncompressed_body.replace(url2_orig, url2_new)
        print(f"Patched '{url2_orig.decode()}' -> '{url2_new.decode()}'")

    print("Recompressing SWF...")
    compressed_body = zlib.compress(uncompressed_body)
    
    new_file_length = 8 + len(uncompressed_body)
    new_file_length_bytes = new_file_length.to_bytes(4, byteorder='little')
    
    new_swf_data = b'CWS' + version + new_file_length_bytes + compressed_body
    
    with open(swf_path, 'wb') as f:
        f.write(new_swf_data)
        
    print("SWF patched successfully!")

if __name__ == "__main__":
    patch_swf()
