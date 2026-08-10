import asyncio
from app.services.ninjasage_client import NinjaSageClient

async def test():
    c = NinjaSageClient()
    for version in ["Public 0.61", "Public 0.62", "Public 0.63"]:
        res = await c.send_amf_request('qgnNJXdbTxOLTF3S.6zWoiSDdFxW3', [version])
        print(f"{version}: {res}")

asyncio.run(test())
