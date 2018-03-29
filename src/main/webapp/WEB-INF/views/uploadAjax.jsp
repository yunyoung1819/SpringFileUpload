<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>

<style>
.fileDrop {
	width: 100%;
	height: 200px;
	border: 1px dotted blue;
}

small {
	margin-left: 3px;
	font-weight: bold;
	color: gray;
}
</style>
</head>
<body>
	
	<h3>Ajax File Upload</h3>
	<div class='fileDrop'></div>
	
	<div class='uploadedList'></div>
	
	<script src="//code.jquery.com/jquery-1.11.3.min.js"></script>
	<script>
		$(".fileDrop").on("dragenter dragover", function(event){
			event.preventDefault();
		});
		
		$(".fileDrop").on("drop", function(event){
			event.preventDefault();
			
			var files = event.originalEvent.dataTransfer.files; // 전달된 파일 데이터를 가져오는 부분
			var file = files[0];
			console.log(file);
			
			// FormData를 이용한 서버 호출
			var formData = new FormData();
			
			formData.append("file", file);
			console.log("formData:", formData);
			
			// Ajax를 이용한 파일 데이터의 전송
			$.ajax({
				url: '/uploadAjax',
				data: formData,
				dataType: 'text',
				processData: false,
				contentType: false,
				type: 'POST',
				success: function(data){
					
					var str = "";
					
					if(checkImageType(data)){
						str ="<div>"
							  +"<img src='displayFile?fileName="+data+"'/>"
							  + data + "</div>";
					}else{
						str = "<div><a href='displayFile?fileName="+data+"'>"
							  + getOriginalName(data)+ 
							  +"</a>"+"</div>";
					}
					
					$(".uploadedList").append(str);
				}
			});
			
		});
		
		// JSP에서 파일 출력하기 
		// 전송받은 문자열이 이미지 파일인지를 확인하는 함수 
		function checkImageType(fileName){
			
			var pattern = /jpg|gif|png|jpeg/i;
			
			return fileName.match(pattern);
		}
		
		// 일반 파일의 이름을 줄여주는 기능 
		function getOriginalName(fileName){
			
			if(checkImageType(fileName)){
				return;
			}
			
			var idx = fileName.indexOf("_") + 1;
			var idx2 = fileName.indexOf("_") - 1;
			
			console.log("fileName : ", fileName);
			console.log("idx : ", idx);
			console.log("idx2 : ", idx2);
			
			return fileName.substr(idx);
		}
		
	</script>
</body>
</html>