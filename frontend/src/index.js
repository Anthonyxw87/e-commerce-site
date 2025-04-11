import React from 'react';
import ReactDOM from 'react-dom/client';
import App from './App';
import { Auth0Provider } from '@auth0/auth0-react';

console.log("Auth0 Domain:", process.env.REACT_APP_AUTH0_DOMAIN);
console.log("Client ID:", process.env.REACT_APP_AUTH0_CLIENT_ID);
console.log("Audience:", process.env.REACT_APP_API_URL);

const root = ReactDOM.createRoot(document.getElementById('root'));

root.render(
    <Auth0Provider
        domain = {process.env.REACT_APP_AUTH0_DOMAIN}
        clientId = {process.env.REACT_APP_AUTH0_CLIENT_ID}
        authorizationParams= {{
            redirect_uri: window.location.origin,
            audience: process.env.REACT_APP_API_AUDIENCE,
        }}
    >
        <App />
    </Auth0Provider>
);