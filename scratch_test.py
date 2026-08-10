from pyamf import remoting, AMF3

# Mock a client request
req = remoting.Request(target="Login.checkVersion", body=[["Public 0.61"]])
env = remoting.Envelope(amfVersion=AMF3)
env["/1"] = req

print("Encoded envelope bodies:", env.bodies)

# Let's decode it
data = remoting.encode(env).getvalue()
decoded_env = remoting.decode(data)

for key, msg in decoded_env.bodies:
    print(f"Tuple key: {key}")
    print(f"Message target: {getattr(msg, 'target', 'No target')}")
    print(f"Message response: {getattr(msg, 'response', 'No response')}")
    print(f"Message body: {msg.body}")
