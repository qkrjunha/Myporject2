const express = require('express')
const oracledb = require('oracledb')
const app = express();

app.set('view engine', 'ejs')
app.set('views', './views')

// npm uninstall oracledb
// npm install oracledb@5.2.0
//oracle 정보 
const dbConfig = {
     user :'java'
    ,password:'oracle'
    ,connectString :'localhost:1521/xe'
}
             
app.get('/', async(req, res) =>{
    let connection;
    try{
                     // 비동기 함수에서 응답을 기다리는 await
        connection = await oracledb.getConnection(dbConfig);
        // execute sql 질의
        const result = await connection.execute("SELECT * FROM employees");
        res.render('index', {data:result.rows});
    }catch(err){
        console.log(err);
        res.status(500).send('error');
    }finally{
        if(connection){
            try{
                await connection.close();
            }catch(err){
                console.log(err);
            }
        }
    }
});

app.get('/emp/:emp_id', async(req, res)=>{
    let conn;
    try{
        const app_id = req.params.emp_id;
        conn = await oracledb.getConnection(dbConfig);
        // :1 :2 위치 바인딩
        // :emp_id :nm 이름 바인딩
        const result = await conn.execute("SELECT * FROM employees WHERE employee_id = :1",[emp_id]);
        res.render('index', {data:result.rows}); 
    }catch(err){
        console.log(err);
        res.status(500).send('error');
    }finally{
        if(connection){
            try{
                await connection.close();
            }catch(err){
                console.log(err);
            }
        }
    }
});

app.listen(3000, ()=>{
    console.log('server start port 3000');
});