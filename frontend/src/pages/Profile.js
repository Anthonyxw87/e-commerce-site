import React from "react";
import { useAuth0 } from "@auth0/auth0-react";

const Profile = () => {
    const { user, logout, isAuthenticated } = useAuth0();

    if (!isAuthenticated) return <div>You need to login first</div>

    return (
        <div>
            <h2>Welcome, user.name</h2>
            <img src={user.picture} alt={user.name}></img>
            <p>Email: {user.email}</p>
            <button onClick={() => logout({ returnTo: window.location.origin })}>
                Log Out
            </button>
        </div>
    );
};

export default Profile;