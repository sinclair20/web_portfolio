웹 개발 포트폴리오 

채팅 + 게시판 웹 사이트 
개요 
- 목적: 다양한 기술을 다양한 방식으로 채팅 및 계층 형 게시판 및 실시간 댓글 웹사이트 구축하여 배포. 
- 개발 인원: 1명 (개인 프로젝트로 모두 혼자 구현) 
- 개발 기간: 2018.08.13 ~ 2018.12.19 
- 주요 기술: Java, Jsp, Servlet, Ajax, Java WebSocket, MySQL, jQuery, Bootstrap  
- 개발 환경: Eclipse Jee Photon, Java JDK 1.8 64bit, Tomcat 8.5, MySQL 8.0.12 community, 
            Apache Maven 3.5.2, AWS EC2 + RDS 에 Ubuntu 운영체제 이용하여 빌드  
- 모든 소스코드는 Github에 올려두었습니다. ( https://github.com/sinclair20/web_portfolio.git ) 
- AWS EC2 서버에 배포하여 실제 이용 가능 (DB는 AWS RDS 서비스 이용하여 구축) 
- URL: http://ec2-13-124-231-86.ap-northeast-2.compute.amazonaws.com:8080/Movie/index.jsp 
 
 
목차  
1. Java WebSocket을 이용한 실시간 멀티 채팅 및 1 : 1 채팅. (회원 / 비회원 경우에 따라 구현) 
- 실시간 단체 채팅 중 원하는 상대와 레이어 팝업 형식으로 채팅 방 만들어 1 : 1 채팅 
2. 친구 찾기 통해 채팅 방 생성 후 1 : 1 채팅 
- 읽지 않은 메시지 개수 뱃지로 표시 
- 부재중 메시지 도착 시 알림 음으로 알려 줌. 
3. 계층 형 게시판 
- 제목, 본문 검색 및 최신 순, 추천 순으로 정렬 가능. 
- 파일 업로드 및 게시 글 수정, 삭제 가능. 
4. 실시간 댓글 
- 무한 스크롤 방식으로 보여주기. 
- 실시간 댓글 작성, 수정, 삭제. (회원 / 비회원 경우에 따라 구현) 
5. AWS 서비스를 통한 서버 배포 
6. 그 외 구현한 기능
- 이메일 인증을 통한 회원가입 
- 자유게시판 내에 신고 기능 통해 게시판 정책에 위반되는 내용 즉시 신고 가능 
- 회원정보 수정 및 프로필 사진 업데이트 구현 
