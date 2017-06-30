import socket
UDP_IP = "10.0.0.64"
UDP_PORT = 6340
MESSAGE = "Hello, World!"

print "UDP target IP:", UDP_IP
print "UDP target port:", UDP_PORT
sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
sock.bind((UDP_IP, UDP_PORT))
while True:
  data = sock.recv(1024) # buffer size is 1024 bytes
  print "received message:", data
