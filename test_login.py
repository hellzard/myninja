import asyncio
from app.services.ninjasage_client import NinjaSageClient
from pyamf import remoting

async def main():
    client = NinjaSageClient()
    version_resp = await client.check_version()
    print("Version Check:", version_resp)
    
    char_underscore = version_resp['_']
    char_double_underscore = version_resp['__']
    
    encrypted_password = client.encrypt_password('mulyono123', char_double_underscore, char_underscore)
    print("Encrypted:", encrypted_password)
    
    bytes_loaded = 14252961
    duar = client.generate_duar(char_underscore)
    nseed = client.generate_nseed(char_underscore)
    
    login_body = [
        'pria solo akan lawan',
        encrypted_password,
        char_underscore,
        bytes_loaded,
        bytes_loaded,
        char_double_underscore,
        duar,
        nseed,
        10
    ]
    print("Login Body:", login_body)
    
    # Try sending raw AMF to see error
    envelope = remoting.Envelope(amfVersion=3) # we use amfVersion=pyamf.AMF3 in client
    request_msg = remoting.Request(target="qgnNJXdbTxOLTF3S.n2znaFWme0q6", body=login_body)
    envelope["/1"] = request_msg
    
    # Actually just call send_amf_request and catch it
    try:
        resp = await client.send_amf_request("qgnNJXdbTxOLTF3S.n2znaFWme0q6", [login_body])
        print("Login Resp:", resp)
        print("Resp type:", type(resp))
        print("Resp vars:", vars(resp))
    except Exception as e:
        print("Exception during send_amf_request:", e)
        if hasattr(e, 'faultCode'):
            print("Fault Code:", getattr(e, 'faultCode', None))
        if hasattr(e, 'faultString'):
            print("Fault String:", getattr(e, 'faultString', None))
        if hasattr(e, 'faultDetail'):
            print("Fault Detail:", getattr(e, 'faultDetail', None))
        print("Type:", type(e))
        
    print("Test complete")

if __name__ == "__main__":
    asyncio.run(main())
