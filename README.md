# web_portfolio

채팅 + 게시판 웹 사이트

개요
-	명칭: 영화 채팅 웹 사이트 
-	개발 인원: 개인 프로젝트로 서버와 클라이언트 모두 혼자 구현
-	개발 기간: 2018.08.13 ~ 2018.12.06
-	주요 기술: Java, Jsp, Servlet, Ajax, WebSocket, jQuery, MySQL, Bootstrap 
-	개발 환경: Eclipse Jee Photon, Java JDK 1.8 64bit, Tomcat 8.5, MySQL 8.0.12 community, Apache Maven 3.5.2, AWS EC2 + RDS 서버에 Ubuntu 운영체제 이용하여 빌드 
-	모든 소스코드는 Github에 올려두었습니다.
-	모든 기능은 AWS EC2 서버에 배포하여 실제로 사용할 수 있도록 해두었습니다. (데이터 베이스는 AWS RDS 서비스 이용하여 구현)
-	URL: http://ec2-13-124-231-86.ap-northeast-2.compute.amazonaws.com:8080/Movie/index.jsp



소개

1.	게시판 (무한 스크롤 방식의 실시간 댓글 작성/수정/삭제 구현)
 
2.	친구 찾기 - Ajax 방식의 1 : 1 채팅 - 안 읽은 메시지 개수 - 부재중 메시지 알림 음    
 
3.	자바 웹소켓을 이용한 실시간 멀티 채팅 구현

4.	 AWS 서비스를 통한 서버 배포 (EC2, RDS)

5.	그 외 구현한 기능
-	이메일 인증을 통한 회원가입
-	게시판 이용 중 신고 기능 만들어 운영자 이메일로 바로 신고 가능 
-	게시 글 작성 및 수정 시 파일 업로드 가능
-	게시 글 조회수 및 좋아요 기능 구현 (좋아요 기능은 게시 글 하나에 동일 유저 한번만 가능)
-	게시 글 검색은 최신 순 및 좋아요 순으로 정렬하여 검색 가능
-	유저 프로필 사진 업데이트 및 회원정보 수정 구현
