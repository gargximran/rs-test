const express = require('express');
const { Client } = require('pg');


const app = express();
const port = 3000;


const client = new Client({
    user: process.env.DB_USER,
    host: process.env.DB_HOST,
    database: process.env.DB_NAME,
    password: process.env.DB_PASSWORD,
    port: process.env.DB_PORT,
});

client.connect()
    .then(() => console.log('Connected to the database'))
    .catch(err => console.error('Connection error', err.stack));

app.get('/', (req, res) => {
    res.send('Database connection test');
});

app.listen(port, () => {
    console.log(`App running on port ${port}`);
});