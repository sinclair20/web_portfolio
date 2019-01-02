package com.movie.chat.open;
//"MessageType"은 "MessageType.java"파일에서 "enum"으로 구현됩니다.
//이 예에서는 두 가지 메시지 유형 만 있습니다. 하나는 대화방에 로그인하기위한 요청에 사용되고 다른 하나는 대화방에서 브로드 캐스트 될 메시지를 보내는 데 사용됩니다.


public enum MessageType { LOGIN, MESSAGE, LOGINTOONECHAT, MESSAGETOONE}
