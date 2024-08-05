var mysql = require('mysql')
const express = require('express');
const router = express.Router();
var md5 = require('md5');
var session = require('express-session');
var data = {};


var con = mysql.createConnection(
    {
        host: "localhost",
        user: "root",
        password: "root",
        database: `plum_v1`
    }
);



chkLogin = (req, res, next) => {
    if (req.session.hasOwnProperty('loggedIn') && req.session.loggedIn == true) {
        next();
    }
    else res.redirect("/");
}

router.get(`/logout`, (req, res) => {
    req.session.loggedIn = false;
    req.session.username = null;
    res.redirect(`/`);
})
router.post('/login', (req, res) => {


    const username = req.body.username;
    const password = md5(req.body.password);


    con.query(
        `SELECT * FROM user WHERE username = ? AND password = ?`,
        [username, password],
        (err, result, field) => {
            if (err) {
                res.send('Error');
            } else if (result.length === 1) {
                data.r1 = result;
                data.f1 = field;

                con.query(`select * from flats where owner = ${data.r1[0].UserId} or tenant = ${data.r1[0].UserId}`,
                    (e2, r2, f2) => {
                        data.r2 = r2;
                        data.f2 = f2;
                        res.redirect('/db/Ud');
                    }
                )
                req.session.loggedIn = true;
                req.session.username = username;
            } else {
                res.send('Wrong Username or Password');
            }
        }
    );
});

router.get(`/Ud`, chkLogin, (req, res) => {
    res.render(`Udashboard`, {
        session: req.session,
        data: data
    });
})

router.get(`/Un`, chkLogin, (req, res) => {
    con.query(`SELECT *
FROM user u
JOIN notice_send_to nst ON u.UserId = nst.userId
JOIN notices n ON nst.noticeId = n.noticeId
WHERE u.username = '${req.session.username}';
`,
        (e1, r1, f1) => {
            data.r1 = r1;
            // console.log(data.r1);
            res.render(`Unoticeboard`, {
                session: req.session,
                data: data
            });
        })
})

router.get(`/Uc`, chkLogin, (req, res) => {

    con.query(`SELECT *
FROM user u
JOIN complaints c ON u.UserId = c.user_id
WHERE u.username = '${req.session.username}';
`, (er, r1, r2) => {
        data.r1 = r1;
        // console.log(data.r1);

        res.render(`Ucomplaint`,
            {
                session: req.session,
                data: data
            }
        );
    })

})

router.post(`/Rcomp`, (req, res) => {
    data.re = 0;
    if (req.body.ccancle) {
        res.redirect(`/db/Uc`)
    }
    else {
        console.log(req.body);
        con.query(`call InsertComplaintByUsername('${req.session.username}', '${req.body.ctitle}', '${req.body.nmsg}')`,
            (e1, r1, r2) => {
                if (e1) {
                    console.log(e1)
                    data.re = 2;
                }
                else {
                    data.re = 1;
                }
                res.redirect(`/db/Uc`);
            }
        )
    }
})



module.exports = router;
