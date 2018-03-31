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
					
					console.log("---------------");
					console.log(data);
					console.log(checkImageType(data));
					console.log("---------------");
					
					if(checkImageType(data)){
						str ="<div>"
							  +"<a href=displayFile?fileName="+getImageLink(data)+">"
							  +"<img src='displayFile?fileName="+data+"'/>"
							  +"</a><small data-src="+data+">X</small></div>";
					}else{
						str = "<div><a href='displayFile?fileName="+data+"'>"
							  + getOriginalName(data)+ 
							  +"</a>"
							  +"<small data-src="+data+">X</small></div>";
					}
					
					$(".uploadedList").append(str);
				}
			});
			
		});
		
		// JSP에서 첨부 파일 삭제 처리
		$(".uploadedList").on("click", "small", function(event){
			
			var that = $(this);
			
			$.ajax({
				url: "deleteFile",
				type: "post",
				data: {fileName:$(this).attr("data-src")},
				dataType: "text",
				success: function(result){
					if(result == 'deleted'){
						alert("deleted");
						// 화면에서 첨부파일을 보여주기 위해서 만들어진 <div> 삭제
						// jQuery의 remove()를 이용
						that.parent("div").remove();
					}
				}
			});
		});
		
		// JSP에서 파일 출력하기 
		// 전송받은 문자열이 이미지 파일인지를 확인하는 함수 
		function checkImageType(fileName){
			
			var pattern = /jpg|gif|png|jpeg/i;
			
			return fileName.match(pattern);
		}
		
		// 파일 링크 처리(일반 파일인 경우 이름을 줄여주기) 
		function getOriginalName(fileName){
			
			if(checkImageType(fileName)){
				return;
			}
			
			var idx = fileName.indexOf("_") + 1;
			
			return fileName.substr(idx);
		}
		
		// 파일 링크 처리(이미지 파일인 경우 원본 파일 찾기)
		function getImageLink(fileName){
			
			if(!checkImageType(fileName)){
				return;
			}
			var front = fileName.substr(0, 12); // 년/월/일
			var end = fileName.substr(14);
			
			return front + end;
		}
		
	</script>
</body>
</html>