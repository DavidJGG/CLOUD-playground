#send message to sqs
import boto3
import json
import threading

sqs = boto3.client('sqs')

def sendMessage(msg, index):
    for i in range(0, index):
        response = sqs.send_message(MessageBody='El mensaje: ' + msg + " --- " + str(i), QueueUrl='https://sqs.us-east-1.amazonaws.com/192552324558/sqs-handler-my-stack-02032024')
        print(response)
    

for i in range(10000):
    hilo = threading.Thread(target=sendMessage, args=("Hola", 10000))
    hilo.start()
