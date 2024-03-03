#send message to sqs
import boto3
import json
import threading

sqs = boto3.client('sqs')

def sendMessage(msg, index):
    for i in range(0, index):
        sqs.send_message(MessageBody='El mensaje: ' + msg + " --- subIndex: " + str(i), QueueUrl='https://sqs.us-east-1.amazonaws.com/192552324558/sqs-handler-my-stack-02032024')
        print("[OK] "+str(i))
    

for i in range(100):
    hilo = threading.Thread(target=sendMessage, args=("Hola hilo principal: "+str(i), i))
    hilo.start()
