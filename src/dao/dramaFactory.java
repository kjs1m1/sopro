package dao;

import vo.DramaBoard;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;

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