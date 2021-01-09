package user;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UserDAO {
	private Connection conn; //데이터 베이스에 접근하게 해주는 객체
	private PreparedStatement pstmt;
	private ResultSet rs;
	
	public UserDAO() {
		try {
			String dbURL = "jdbc:mysql://localhost:3306/BBS?characterEncoding=UTF-8&serverTimezone=UTC";
			String dbID = "root";
			String dbPassword = "23er";
			
			Class.forName("com.mysql.jdbc.Driver");  //Driver: sql에 접속할 수 있는 매개체 역할을 하는 라이브러리
			
			conn = DriverManager.getConnection(dbURL, dbID, dbPassword);	// DB 접속되면 conn객체에 접속정보가 저장 
		} catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	public int login(String userID, String userPassword) {
		String SQL = "SELECT userPassword FROM USER WHERE userID= ?"; 	//물음표에 해당하는 id값이 매개변수로 넘어가고, 그 아이디에 해당하는 비밀번호가 무엇인지 가져오는 형식
		try {
			pstmt = conn.prepareStatement(SQL); //pstmt에 정해진 sql문장을 삽입하는 형식으로 인스턴스 가져오기
			pstmt.setString(1, userID); //setString(int index, String x) / sql 인젝션과 같은 해킹 방어 수단, 물음표에 해당하는 내용으로 db에 유저아이디를 넣어줌
			rs = pstmt.executeQuery();  //결과를 담을 수 있는 객체 생성
			
			if(rs.next()) { //결과가 존재할 시 이쪽이 실행됨
				if(rs.getString(1).equals(userPassword)) //rs.getString(1): 결과로 나온 userPassword 받아오기
					return 1; //로그인 성공
				else 
					return 0; //비밀번호 불일치
			}
			return -1; //아이디가 없음
		} catch(Exception e) {
			e.printStackTrace();
		}
		return -2; //데이터 베이스 오류
	}
	
	public int join(User user) {
		String SQL = "INSERT INTO USER VALUES(?, ?, ?, ?, ?)";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, user.getUserID());
			pstmt.setString(2, user.getUserPassword());
			pstmt.setString(3, user.getUserName());
			pstmt.setString(4, user.getUserGender());
			pstmt.setString(5, user.getUserEmail());			
			return pstmt.executeUpdate();
		} catch(Exception e) {
			e.printStackTrace();
		} 
		return -1; //데이터베이스 오류
	}
}
