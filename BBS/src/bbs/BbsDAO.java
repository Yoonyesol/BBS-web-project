package bbs;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class BbsDAO {
	private Connection conn; //데이터 베이스에 접근하게 해주는 객체
	private PreparedStatement pstmt;
	private ResultSet rs;
	
	public BbsDAO() {
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
	
	public String getDate() { //현재시간 넣어주는 함수
		String SQL = "SELECT NOW()"; //현재 시간 가져오는 MYSQL문장
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL); //SQL문장을 실행준비 단계로 만들어준다
			rs = pstmt.executeQuery(); //쿼리문 실행한 결과를 rs변수에 담는다
			if(rs.next()) { //결과가 있는 경우
				return rs.getString(1); //현재 날짜 반환
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return ""; //db오류
	}
	
	public int getNext() {
		String SQL = "SELECT bbsID FROM BBS ORDER BY bbsID DESC"; //내림차순 해서 가장 마지막에 쓰인 글 번호를 가져오는 쿼리문
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL); //SQL문장을 실행준비 단계로 만들어준다
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getInt(1) + 1;  //이전 게시물 번호에 1을 더해 다음 게시글 번호 만들어주기
			}
			return 1; //첫번째 게시물인 경우
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; //db오류, 게시글로 적절하지 않은 숫자를 반환
	}
	
	public int write(String bbsTitle, String userID, String bbsContent) {
		String SQL = "INSERT INTO BBS VALUES(?,?,?,?,?,?)"; 
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL); 
			pstmt.setInt(1, getNext());
			pstmt.setString(2, bbsTitle);
			pstmt.setString(3, userID);
			pstmt.setString(4, getDate());
			pstmt.setString(5, bbsContent);
			pstmt.setInt(6, 1);
			return pstmt.executeUpdate(); //insert: 성공 시 0이상의 결과를 반환
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; //db오류
	}
	
	public ArrayList<Bbs> getList(int pageNumber){
		String SQL = "SELECT * FROM BBS WHERE bbsID < ? AND bbsAvailable = 1 ORDER BY bbsID DESC LIMIT 10"; //BBSID가 특정숫자보다 작을 때 & 삭제가 되지 않아 Available이 1인 글들만 내림차순 정렬으로 위에서부터 10개까지만 가져오는 쿼리문	
		ArrayList<Bbs> list = new ArrayList<Bbs>(); //Bbs 클래스에서 나오는 인스턴스를 보관할 수 있는 리스트 생성
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL); //SQL문장을 실행준비 단계로 만들어준다
			pstmt.setInt(1, getNext() - (pageNumber - 1) * 10); //getNext(): 다음으로 작성될 글의 번호
			rs = pstmt.executeQuery();
			while(rs.next()) {  //결과로 나온 모든 게시글 목록을 리스트에 담아서 반환
				Bbs bbs = new Bbs();
				bbs.setBbsID(rs.getInt(1));
				bbs.setBbsTitle(rs.getString(2));
				bbs.setUserID(rs.getString(3));
				bbs.setBbsDate(rs.getString(4));
				bbs.setBbsContent(rs.getString(5));
				bbs.setBbsAvailable(rs.getInt(6));
				list.add(bbs);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}
	
	public boolean nextPage(int pageNumber) {  //다음 게시물이 없을 경우를 처리하는 페이징 처리 함수
		String SQL = "SELECT * FROM BBS WHERE bbsID < ? AND bbsAvailable = 1";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL); 
			pstmt.setInt(1, getNext() - (pageNumber - 1) * 10); 
			rs = pstmt.executeQuery();
			if(rs.next()) {  //다음 글이 존재한다면
				return true; //true 반환
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;  //다음 글이 존재하지 않는 경우 false 반환
	}
	
	public Bbs getBbs(int bbsID) {  //게시물을 불러오는 함수
		String SQL = "SELECT * FROM BBS WHERE bbsID = ?";  //bbsID가 특정 숫자인 경우 동작 
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL); 
			pstmt.setInt(1, bbsID);  //bbsID가 특정 값인 경우
			rs = pstmt.executeQuery();
			if(rs.next()) {  //해당 글이 존재하는 경우
				Bbs bbs = new Bbs();
				bbs.setBbsID(rs.getInt(1));
				bbs.setBbsTitle(rs.getString(2));
				bbs.setUserID(rs.getString(3));
				bbs.setBbsDate(rs.getString(4));
				bbs.setBbsContent(rs.getString(5));
				bbs.setBbsAvailable(rs.getInt(6));
				return bbs;  //bbs인스턴스 그대로 반환
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;  //해당 글이 존재하지 않는 경우
	}
	
	public int update(int bbsID, String bbsTitle, String bbsContent) {
		String SQL = "UPDATE BBS SET bbsTitle = ?, bbsContent = ? WHERE	bbsID = ?"; 
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL); 
			pstmt.setString(1, bbsTitle);
			pstmt.setString(2, bbsContent);
			pstmt.setInt(3, bbsID);
			return pstmt.executeUpdate(); //성공 시 0이상의 결과를 반환
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; //db오류
	}
	
	public int delete(int bbsID) {
		String SQL = "UPDATE BBS SET bbsAvailable = 0 WHERE bbsID = ?"; 
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL); 
			pstmt.setInt(1, bbsID);
			return pstmt.executeUpdate(); //성공 시 0이상의 결과를 반환
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; //db오류
	}
}
