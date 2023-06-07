const express = require('express');
const app = express();
const path = require('path');
const bcrypt = require('bcrypt');
const db = require('./db');

app.set('view engine', 'ejs');
app.use(express.static('./public'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));

const sqlConfig = {
  user_info: `SELECT *
              FROM MD_USER 
              WHERE user_id = :1`,
  user_insert: `INSERT INTO MD_USER 
                VALUES(:user_id, :user_pw, :user_nm)`
};

let conn;

async function dbrun() {
  conn = await db.getConn();
  console.log('db start');
}

dbrun();

app.get('/', async (req, res) => {
  res.render('sign', { msg: 'N' });
});

app.get('/loginPage', async (req, res) => {
  res.render('login', { msg: 'N', id: '' });
});

app.post('/signup', async (req, res) => {
  const user_pw = await bcrypt.hash(req.body.user_pw, 10);
  const user_id = req.body.user_id;
  const user_nm = req.body.user_nm;

  try {
    const result = await db.selectData(conn, sqlConfig.user_info, [user_id]);
    if (result.rows.length > 0) {
      return res.render('sign', { msg: '동일한 아이디가 있음' });
    }
  } catch (error) {
    return res.render('sign', { msg: '사이트 오류' });
  }

  const val = { user_id, user_pw, user_nm };
  try {
    await db.insertData(conn, sqlConfig.user_insert, val);
    res.render('login', { id: user_id, msg: '회원 가입 되셨습니다. 로그인 진행해 주세요!!' });
  } catch (error) {
    res.render('sign', { msg: '사이트 오류' });
  }
});

app.post('/login', async (req, res) => {
  const user_id = req.body.user_id;

  try {
    const result = await db.selectData(conn, sqlConfig.user_info, [user_id]);
    console.log(result);
    if (result.rows.length > 0) {
      bcrypt.compare(req.body.user_pw, result.rows[0].USER_PW, function (err, isMatch) {
        if (err) {
          console.log(err);
        } else if (isMatch) {
          res.redirect('index');
        } else {
          res.render('login', { msg: '비밀번호가 다릅니다.', id: user_id });
        }
      });
    } else {
      res.render('login', { msg: '잘못된 회원 아이디 입니다.', id: '' });
    }
  } catch (e) {
    console.log(e);
  }
});

const multer = require('multer');
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, 'uploads/');
  },
  filename: (req, file, cb) => {
    cb(null, file.fieldname + '-' + Date.now());
  }
});
const upload = multer({ storage: storage });

app.use('/uploads', express.static('./uploads'));

app.post('/upload', upload.single('myfile'), async (req, res) => {
  const file = req.file;
  const meta = {
    user_id: req.body.user_id,
    originalname: file.originalname,
    mimetype: file.mimetype,
    f_size: file.size,
    destination: file.destination,
    filename: file.filename
  };

  try {
    const result = await db.insertData(conn, sqlConfig.file_insert, meta);
    console.log('insert rowcnt :' + result.rowsAffected);
  } catch (err) {
    console.log(err);
  }

  res.render('main', { msg: '저장 되었습니다.', id: req.body.user_id });
});

app.post('/mypage', async (req, res) => {
  const user_id = req.body.user_id;
  try {
    const result = await db.selectData(conn, sqlConfig.file_select, [user_id]);
    res.render('mypage', { files: result.rows });
  } catch (err) {
    res.render('main', { msg: '유저 정보가 잘못 되었습니다.', id: user_id });
    console.log(err);
  }
});

app.get('/index', (req, res) => {
    res.render('index');
});

app.listen(3000, () => {
  console.log('Server started on port 3000');
});

process.on('SIGINT', async () => {
  console.log('SIGINT closing db');
  await db.closeConn(conn);
  process.exit(0);
});

process.on('SIGTERM', async () => {
  console.log('SIGTERM closing db');
  await db.closeConn(conn);
  process.exit(0);
});
