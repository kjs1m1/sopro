package dao;

import vo.DramaBoard;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

//게시판 jdbc 연결 나중에 spring 으로 변경 해야함
public class dramaFactory {

    private PreparedStatement pstmt = null;
    private ResultSet rs;

    private Connection conn;
    private static String DRV = "oracle.jdbc.OracleDriver";
    private static String URL = "jdbc:oracle:thin:@15.164.231.42/XE";
    private static String UID = "scott";
    private static String PWD = "tiger";

    public Connection makeConn() {

        try {
            Class.forName(DRV);
            conn = DriverManager.getConnection(URL, UID, PWD);

        } catch (Exception ex) {
            ex.printStackTrace();

        }

        return conn;
    }
    //글 쓰기 게시판 작성 -옵션태그 선택에 따라 해당 게시판 insert
    public int dramaWrite(Map<String, String> frmdata, String selectWrite){

        String wirteSQL = "";
        //선택한 해방 게시판에 insert(dramaWrite에 옵션 값(selectWrite로 지정하여 가져옴))

        switch (selectWrite) {
            case "kbs":
                writeSQL = "INSERT into kbsboard (bdno, userid, title, contents, file1, file2, file3, file4, file5) VALUES (SQU.nextval,?,?,?,?,?,?,?,?)";
                break;
            case "mbc":
                writeSQL = "INSERT into mbcboard (bdno, userid, title, contents, file1, file2, file3, file4, file5) VALUES (DOGC_SEQ.nextval,?,?,?,?,?,?,?,?)";
                break;
            case "sbs":
                writeSQL = "INSERT into sbsboard (bdno, userid, title, contents, file1, file2, file3, file4, file5) VALUES (catc_seq.nextval,?,?,?,?,?,?,?,?)";
                break;
            case "tvn":
                writeSQL = "INSERT into tvnboard (bdno, userid, title, contents, file1, file2, file3, file4, file5) VALUES (QNA_SEQ.nextval,?,?,?,?,?,?,?,?)";
                break;
            case "jdbc":
                writeSQL = "INSERT into jtbcboard (bdno, userid, title, contents, file1, file2, file3, file4, file5) VALUES (review_seq.nextval,?,?,?,?,?,?,?,?)";
                break;
        }

        int check = 0;

        try {
            conn = makeConn();
            pstmt = conn.prepareStatement(writeSQL);
            pstmt.setString(1, frmdata.get("userid"));
            pstmt.setString(2, frmdata.get("title"));
            pstmt.setString(3, frmdata.get("contents"));
            pstmt.setString(4, frmdata.get("file1"));
            pstmt.setString(5, frmdata.get("file2"));
            pstmt.setString(6, frmdata.get("file3"));

        } catch (Exception ex){
            ex.printStackTrace();
        }finally {
            makeConn(pstmt, conn);
        }
        return check;
    }





    public ArrayList<DramaBoard> dramaList(HashMap<String, String> searchList) {
        String listSQL = " ";
        String val = "";

        for (String key : searchList.keySet()) {
            switch (key) {
                case "title":
                    listSQL = "select bdno,userid,title,contents,views,regdate,file1 from drama where title like '%'|| ? ||'%' order by regdate desc";
                    break;
                case "contents":
                    listSQL = "select bdno,userid,title,contents,views,regdate,file1 from drama where contents like '%'|| ? ||'%' order by regdate desc";
                    break;
                case "userid":
                    listSQL = "select bdno,userid,title,contents,views,regdate,file1 from drama where userid like '%'|| ? ||'%' order by regdate desc";
                    break;
                case "selected":
                    listSQL = "select bdno,userid,title,contents,views,regdate,file1 from drama order by regdate desc";
                    break;
            }
            val = searchList.get(key);

            System.out.println("넘어온 vlaue : " + val);
            System.out.println("넘어온 key : " + key);
        }

        ArrayList<DramaBoard> dblists = new ArrayList<>();

        try {
            conn = makeConn();
            pstmt = conn.prepareStatement(listSQL);

            // key에 해당하는 value 값이 있을때 작동
            if (!val.equals("")) {
                pstmt.setString(1, val);
            }

            rs = pstmt.executeQuery();

            while (rs.next()){
                DramaBoard db = new DramaBoard();
                db.setBdno(rs.getInt(1));
                db.setUserid(rs.getString("userid"));
                db.setTitle(rs.getString("title"));
                db.setContents(rs.getString("contents"));
                db.setViews(rs.getInt("views"));
                db.setRegdate(rs.getString("regdate"));
                db.setTitle(rs.getString("file1"));

                dblists.add(db);
            }




        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("baardList 메소드 에러");
        } finally {
            makeConn();
        }
        return dblists;
    }
}