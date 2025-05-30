CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  auth0_id TEXT UNIQUE NOT NULL
  name TEXT NOT NULL,
  email TEXT UNIQUE NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert test data
INSERT INTO users (name, auth0_id, email) VALUES
('Alice', '102296435422432', 'alice@example.com'),
('Bob', '107343616241362', 'bob@example.com');
