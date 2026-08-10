import zlib
import re

swf_path = r"C:\Users\acer\Downloads\NinjaSage\NinjaSage.swf"

def extract_urls(file_path):
    with open(file_path, 'rb') as f:
        signature = f.read(3)
        version = f.read(1)
        length = f.read(4)
        
        # Read the rest of the file
        data = f.read()
        
        if signature == b'CWS':
            print("SWF is compressed (zlib). Decompressing...")
            try:
                uncompressed_data = zlib.decompress(data)
            except Exception as e:
                print(f"Error decompressing: {e}")
                return
        elif signature == b'FWS':
            print("SWF is not compressed.")
            uncompressed_data = data
        else:
            print(f"Unknown signature: {signature}")
            return
            
        print(f"Uncompressed length: {len(uncompressed_data)} bytes")
        
        # Find all HTTP/HTTPS URLs
        urls = set()
        # Find ASCII strings looking like URLs
        pattern = re.compile(rb'https?://[^\x00-\x1f"\'\s]+')
        for match in pattern.finditer(uncompressed_data):
            try:
                url = match.group(0).decode('utf-8')
                urls.add(url)
            except:
                pass
                
        # Find absolute paths (starting with / and ending with .php)
        php_pattern = re.compile(rb'/[^\x00-\x1f"\'\s]+\.php')
        for match in php_pattern.finditer(uncompressed_data):
            try:
                url = match.group(0).decode('utf-8')
                urls.add(url)
            except:
                pass
                
        print("\nExtracted URLs:")
        for url in sorted(urls):
            print(url)
            
if __name__ == "__main__":
    extract_urls(swf_path)
