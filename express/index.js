    var express = require('express');
    var md5 = require('md5');
    var path = require('path');
    var session = require('express-session'); 
    
    var port = 3000;
    var myApp = express();
    const bodyParser = require('body-parser');
    myApp.use(bodyParser.urlencoded({ extended: false }));
    myApp.use(bodyParser.json());

    myApp.set('views', path.join(__dirname, 'views'));
    myApp.set('view engine', 'ejs');
    myApp.use(session({ 
                            // It holds the secret key for session 
                            secret: 'AlphaZulu16', 
                        
                            // Forces the session to be saved 
                            // back to the session store 
                            resave: true, 
                        
                            // Forces a session that is "uninitialized" 
                            // to be saved to the store 
                            saveUninitialized: true
                        }
                    )) 


    var db = require('./DB/db');
    myApp.get('/',(req,res)=>{res.render(`login`,{session:req.session});});

    myApp.use('/db',db);
    myApp.listen(port,()=>{console.log(`Server is running on http://localhost:${port}`)});
