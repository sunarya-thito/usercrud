import { Sequelize, DataTypes } from 'sequelize';

import express from 'express';
import bodyParser from 'body-parser';
import cors from 'cors';

import pg from 'pg';

// using postgres from vercel
const sequelize = new Sequelize(process.env.POSTGRES_URL, {
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

export const app = express();
app.use(cors());
app.use(bodyParser.json());

function vercelHeaders(res) {
    res.setHeader('Cache-Control', 's-maxage=1, stale-while-revalidate');
}

// POST /login?username&password -> username, name, email
app.post('/login', async (req, res) => {
    vercelHeaders(res);
    let username = req.query.username;
    let password = req.query.password;
    let user = await User.findOne({
        where: {
            username: username,
            password: password,
        }
    });
    if (user === null) {
        res.status(401);
        res.send('Tidak dapat login');
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
    res.send(JSON.stringify(users));
});

// POST /user?username&password&name&email -> {userid}
app.post('/user', async (req, res) => {
    vercelHeaders(res);
    // validasi input
    let username = req.body.username;
    let password = req.body.password;
    let name = req.body.name;
    let email = req.body.email;
    if (username === undefined || password === undefined || name === undefined || email === undefined) {
        res.status(400);
        res.send('Bad request');
        return;
    }
    let user = await User.create({
        username: username,
        password: password,
        name: name,
        email: email,
    });
    res.send(JSON.stringify({
        userid: user.userid,
    }));
});