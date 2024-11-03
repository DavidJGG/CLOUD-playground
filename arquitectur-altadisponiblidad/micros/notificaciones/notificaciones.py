from flask import Flask, request, jsonify
import boto3

app = Flask(__name__)
sns_client = boto3.client('sns')

@app.route('/notifications', methods=['POST'])
def send_notification():
    data = request.json
    response = sns_client.publish(
        PhoneNumber=data['phone_number'],  # O utiliza TopicArn si prefieres
        Message=data['message']
    )
    return jsonify({'message': 'Notification sent!', 'response': response}), 200

if __name__ == '__main__':
    app.run(debug=True)
