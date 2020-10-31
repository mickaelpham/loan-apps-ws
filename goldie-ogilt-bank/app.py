from flask import Flask, request, jsonify, abort

app = Flask(__name__)

"""
The bank owned by Ms. Goldie O'Gilt doesn't handle
credit scores, because these weren't available in the far
North (Klondike). Instead, they will lend you money if you
ask for less than $500, otherwise you are denied.
"""
@app.route('/klondike-loans', methods=['POST'])
def request_loan():
    if not request.json or not 'amount' in request.json:
        abort(400)

    loan_request = {
        'approved': request.json['amount'] <= 500,
        'interest_rate': 0.15
    }

    return jsonify(loan_request), 201
