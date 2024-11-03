from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://username:password@your-rds-endpoint/dbname'
db = SQLAlchemy(app)

class Event(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(100), nullable=False)
    description = db.Column(db.String(200), nullable=False)
    date = db.Column(db.String(50), nullable=False)

@app.route('/events', methods=['POST'])
def create_event():
    data = request.json
    new_event = Event(title=data['title'], description=data['description'], date=data['date'])
    db.session.add(new_event)
    db.session.commit()
    return jsonify({'message': 'Event created!'}), 201

@app.route('/events', methods=['GET'])
def get_events():
    events = Event.query.all()
    return jsonify([{'id': e.id, 'title': e.title, 'description': e.description, 'date': e.date} for e in events])

@app.route('/events/<int:event_id>', methods=['GET'])
def get_event(event_id):
    event = Event.query.get_or_404(event_id)
    return jsonify({'id': event.id, 'title': event.title, 'description': event.description, 'date': event.date})

if __name__ == '__main__':
    app.run(debug=True)
