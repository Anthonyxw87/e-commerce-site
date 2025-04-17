from flask import Blueprint, jsonify
from src.utils.auth import requires_auth

user_bp = Blueprint("user", __name__)

@user_bp.route("/profile", methods=["GET"])
@requires_auth
def profile():
    return jsonify({"payload": g.current_user})
