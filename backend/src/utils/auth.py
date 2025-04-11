import json
from functools import wraps
from flask import request, abort, g
from jose import jwt
import requests
import os

AUTH0_DOMAIN = os.getenv("AUTH0_DOMAIN")
API_AUDIENCE = os.getenv("API_AUDIENCE")

class AuthError(Exception):
    def __init__(self, error, status_code):
        self.error = error
        self.status_code = status_code

def get_token_auth_header():
    auth = request.headers.get("Authorization", None)

    if not auth:
        raise AuthError({"code": "authorization_header_missing"}, 401)
    
    parts = auth.split()
    
    if parts[0].lower() != "bearer":
        raise AuthError({"code": "invalid_header"}, 401)
    elif len(parts) == 1 or len(parts) > 2: 
        raise AuthError({"code": "invalid_header"}, 401)
    
    token = parts[1]
    return token

def requires_auth(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        token = get_token_auth_header()
        jsonurl = requests.get(f"https://{AUTH0_DOMAIN}/.well-known/jwks.json")
        jwks = jsonurl.json()
        unverified_header = jwt.get_unverified_header(token)
        
        rsa_key = {}
        for key in jwks["keys"]:
            if key["kid"] == unverified_header["kid"]:
                rsa_key = {
                    "kty": key["kty"],
                    "kid": key["kid"],
                    "use": key["use"],
                    "n": key["n"],
                    "e": key["e"],
                }
        if not rsa_key:
            raise AuthError({"code": "invalid_header"}, 401)
        
        try:
            payload = jwt.decode(
                token,
                rsa_key,
                algorithms=["RS256"],
                audience=API_AUDIENCE,
                issuer=f"https://{AUTH0_DOMAIN}/"
            )
            
            # Store user info in Flask's g object
            g.current_user = payload
            return f(*args, **kwargs)
        except jwt.ExpiredSignatureError:
            raise AuthError({"code": "token_expired"}, 401)
        except jwt.JWTClaimsError:
            raise AuthError({"code": "invalid_claims"}, 401)
        except Exception:
            raise AuthError({"code": "invalid_token"}, 401)
        
    return decorated