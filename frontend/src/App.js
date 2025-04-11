import React from 'react';
import { BrowserRouter as Router, Routes, Route, Link } from "react-router-dom"
import Login from "./pages/Login"
import Profile from './pages/Profile';

function App() {
  return (
    <Router>
      <nav>
        <Link to="/">Login</Link> | <Link to="/profile">Profile</Link>
      </nav>
      <Routes>
        <Route path="/" element={<Login />} />
        <Route path="/profile" element={<Profile />} />
      </Routes>
    </Router>
  );
};

export default App;
