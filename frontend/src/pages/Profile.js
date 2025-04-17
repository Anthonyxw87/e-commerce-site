import React, { useState } from "react";
import { useAuth0 } from "@auth0/auth0-react";

const ENV = process.env.REACT_APP_ENV;
const BACKEND_URL = ENV === "dev" ? `http://localhost:5002` : `${process.env.REACT_APP_BACKEND_API}`

const Profile = () => {
    const { user, logout, isAuthenticated, getAccessTokenSilently, getIdTokenClaims } = useAuth0();
    const [payload, setPayload] = useState(null);
    const [error, setError] = useState(null);

    const loadProfile = async () => {
        try {
            const accessToken = await getAccessTokenSilently();
            const idToken = await getIdTokenClaims().__raw;

            const response = await fetch(`${BACKEND_URL}/api/profile`, {
                headers: {
                    Authorization: `Bearer ${idToken}`,
                },
            });

            if (!response.ok) {
                throw new Error("Failed to load profile");
            }

            const data = await response.json();
            setPayload(data.payload); // since Flask returns { payload: ... }
        } catch (err) {
            setError(err.message);
        }
    };

    if (!isAuthenticated) return <div>You need to login first</div>;

    return (
        <div>
            <h2>Welcome, {user.name}</h2>
            <img src={user.picture} alt={user.name} style={{ borderRadius: "50%" }} />
            <p>Email: {user.email}</p>

            <button onClick={() => logout({ returnTo: window.location.origin })}>
                Log Out
            </button>

            <button onClick={loadProfile} style={{ marginLeft: "1rem" }}>
                Load Payload
            </button>

            {payload && (
                <pre style={{ marginTop: "1rem", background: "#f4f4f4", padding: "1rem", borderRadius: "6px" }}>
                    {JSON.stringify(payload, null, 2)}
                </pre>
            )}

            {error && <p style={{ color: "red" }}>{error}</p>}
        </div>
    );
};

export default Profile;