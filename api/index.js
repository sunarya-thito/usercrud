import { Sequelize, DataTypes } from 'sequelize';

import express from 'express';
import bodyParser from 'body-parser';
import cors from 'cors';
import bcrypt from 'bcrypt';
import pg from 'pg';

// using postgres from vercel
const sequelize = new Sequelize(process.env.POSTGRES_URL + '?sslmode=require', {
    dialect: 'postgres',
    dialectModule: pg, // <- PENTING UNTUK VERCEL
    dialectOptions: {
        ssl: {
            rejectUnauthorized: false,
        }
    }
});

const User = sequelize.define('user', {
    userid: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true,
    },
    username: {
        type: DataTypes.STRING(320),
    },
    password: {
        type: DataTypes.STRING(255),
    },
    name: {
        type: DataTypes.STRING(255),
    },
    email: {
        type: DataTypes.STRING(320),
    }
});

await sequelize.sync();

const app = express();
export default app;
app.use(cors({
    origin: '*',
    methods: '*',
    allowedHeaders: '*',
    credentials: true,
}));
app.use(bodyParser.urlencoded());
app.use(bodyParser.json());

function vercelHeaders(res) {
    res.setHeader('Cache-Control', 's-maxage=1, stale-while-revalidate');
}

// POST /login?username&password -> username, name, email
app.post('/login', async (req, res) => {
    vercelHeaders(res);
    let username = req.query.username;
    let password = req.query.password;
    if (username === undefined || password === undefined) {
        res.status(400);
        res.send({
            error: 'Invalid request',
        });
        return;
    }
    let user = await User.findOne({
        where: {
            username: username,
            password: password,
        }
    });
    if (user === null) {
        res.status(400);
        res.send({
            error: 'Username or password is incorrect',
        });
        return;
    }
    res.send(JSON.stringify({
        username: user.username,
        name: user.name,
        email: user.email,
    }));
});

// GET /user -> [{userid, username, password, name, email}]
app.get('/user', async (req, res) => {
    vercelHeaders(res);
    let users = await User.findAll();
    let usersJson = [];
    for (let user of users) {
        usersJson.push({
            userid: user.userid,
            username: user.username,
            name: user.name,
            email: user.email,
        });
    }
    res.send(JSON.stringify(usersJson));
});

// POST /user?username&password&name&email -> {userid}
app.post('/user', async (req, res) => {
    vercelHeaders(res);
    // validasi input
    let username = req.query.username;
    let password = req.query.password;
    let name = req.query.name;
    let email = req.query.email;
    if (username === undefined || password === undefined || name === undefined || email === undefined) {
        res.status(400);
        res.send({
            error: 'Invalid request',
        });
        return;
    }
    // cek apakah username sudah ada
    let exUser = await User.findOne({
        where: {
            username: username,
        }
    });
    if (exUser !== null) {
        res.status(400);
        res.send({
            error: 'Username already exists',
        });
        return;
    }
    let user = await User.create({
        username: username,
        name: name,
        email: email,
        password: password,
    });
    res.send(JSON.stringify({
        userid: user.userid,
    }));
});