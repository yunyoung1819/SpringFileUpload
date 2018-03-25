package org.zerock.util;

import java.awt.image.BufferedImage;
import java.io.File;
import java.text.DecimalFormat;
import java.util.Calendar;
import java.util.UUID;

import javax.imageio.ImageIO;

import org.imgscalr.Scalr;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.util.FileCopyUtils;

/**
 * 파일 업로드용 클래스 
 * 
 * 업로드 시
 * 1) 자동적인 폴더의 생성
 * 2) 파일 저장은 UUID를 이용해서 처리
 * 3) 썸네일 이미지를 생성
 *
 */
public class UploadFileUtils {

	private static final Logger logger = LoggerFactory.getLogger(UploadFileUtils.class);
	
	// 파일을 업로드하기 위해서는 적어도 다음과 같은 3개의 데이터가 필요
	// 1) 파일의 저장 경로(uploadPath)
	// 2) 원본 파일의 이름(originalName)
	// 3) 파일 데이터(byte[])
	public static String uploadFile(String uploadPath, String originalName, byte[] fileData) throws Exception {
		
		UUID uid = UUID.randomUUID();
		String savedName = uid.toString() + "_" + originalName;
		String savedPath = calcPath(uploadPath);
		File target = new File(uploadPath + savedPath, savedName);
		FileCopyUtils.copy(fileData, target);
		
		String formatName = originalName.substring(originalName.lastIndexOf(".")+1);
		String uploadedFileName = null;
		
		if(MediaUtils.getMediaType(formatName) != null){
			uploadedFileName = makeThumbnail(uploadPath, savedPath, savedName);
		}else{
			uploadedFileName = makeIcon(uploadPath, savedPath, savedName);
		}
		
		return uploadedFileName;
	}
	
	private static String makeIcon(String uploadPath, String path, String fileName) throws Exception{
		String iconName = uploadPath + path + File.separator + fileName;
		
		return iconName.substring(uploadPath.length()).replace(File.separatorChar, '/');
	}
	
	// 업로드 폴더의 생성 처리 (년월일 계산)
	private static String calcPath(String uploadPath){
		
		Calendar cal = Calendar.getInstance();
		
		String yearPath = File.separator + cal.get(Calendar.YEAR);
		
		String monthPath = yearPath + File.separator + new DecimalFormat("00").format(cal.get(Calendar.MONTH) + 1);
		
		String datePath = monthPath + File.separator + new DecimalFormat("00").format(cal.get(Calendar.DATE));

		System.out.println("cal : " + cal);
		System.out.println("file separator :" + File.separator);
		System.out.println("yearPath : " + yearPath);
		System.out.println("monthPath : " + monthPath);
		System.out.println("datePath : " + datePath);
		
		makeDir(uploadPath, yearPath, monthPath, datePath);
		
		logger.info(datePath);
		
		return datePath;
		
	}
	
	/* 업로드 폴더 생성 */
	private static void makeDir(String uploadPath, String... paths){
		
		System.out.println("paths : " + paths);
		
		if(new File(paths[paths.length-1]).exists()){
			return;
		}
		
		for (String path : paths){
			
			File dirPath = new File(uploadPath + path);
			
			if(!dirPath.exists()){
				dirPath.mkdir();
			}
		}
	}
	
	/* 썸네일 이미지 생성하기 */
	private static String makeThumbnail(String uploadPath, String path, String fileName) throws Exception {
		
		BufferedImage sourceImg = ImageIO.read(new File(uploadPath + path, fileName));
		
		BufferedImage destImg = Scalr.resize(sourceImg, Scalr.Method.AUTOMATIC, Scalr.Mode.FIT_TO_HEIGHT, 100);
		
		String thumbnailName = uploadPath + path + File.separator + "s_" + fileName; // 썸네일 파일명
 		
		File newFile = new File(thumbnailName);
		String formatName = fileName.substring(fileName.lastIndexOf(".")+1);
		
		ImageIO.write(destImg, formatName.toUpperCase(), newFile);
		return thumbnailName.substring(uploadPath.length()).replace(File.separatorChar, '/');
	}
}
