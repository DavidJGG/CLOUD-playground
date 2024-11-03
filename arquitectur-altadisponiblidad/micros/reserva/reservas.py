from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://username:password@your-rds-endpoint/dbname'
db = SQLAlchemy(app)

class Reservation(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    event_id = db.Column(db.Integer, nullable=False)
    user_email = db.Column(db.String(100), nullable=False)

@app.route('/reservations', methods=['POST'])
def create_reservation():
    data = request.json
    new_reservation = Reservation(event_id=data['event_id'], user_email=data['user_email'])
    db.session.add(new_reservation)
    db.session.commit()
    return jsonify({'message': 'Reservation created!'}), 201

@app.route('/reservations', methods=['GET'])
def get_reservations():
    reservations = Reservation.query.all()
    return jsonify([{'id': r.id, 'event_id': r.event_id, 'user_email': r.user_email} for r in reservations])

if __name__ == '__main__':
    app.run(debug=True)
