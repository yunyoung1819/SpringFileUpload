package org.zerock.controller;

import java.io.File;
import java.util.UUID;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.multipart.MultipartFile;

/**
 * 일반적인 파일 업로드 실습
 * @author Administrator
 *
 */
@Controller
public class UploadController {

	// 파일 경로
	@Resource(name = "uploadPath")
	private String uploadPath;
	
	private static final Logger logger = LoggerFactory.getLogger(UploadController.class);
	
	@RequestMapping(value = "/uploadForm", method = RequestMethod.GET)
	public void uploadForm(){
		
	}
	
	@RequestMapping(value = "/uploadForm", method = RequestMethod.POST)
	public void uploadForm(MultipartFile file, Model model) throws Exception {
		
		logger.info("originalName : " + file.getOriginalFilename());
		logger.info("size: " + file.getSize());
		logger.info("contentType: " + file.getContentType());
		
		String savedName = uploadFile(file.getOriginalFilename(), file.getBytes());
		
		model.addAttribute("savedName", savedName);
	}
	
	private String uploadFile(String originalName, byte[] fileData) throws Exception {
		
		UUID uid = UUID.randomUUID();
		
		String savedName = uid.toString() + "_" + originalName;  // 파일 저장명 : uid + "_" + 원본명
		
		File target = new File(uploadPath, savedName);
		
		FileCopyUtils.copy(fileData, target);
		
		return savedName;
		
	}
}
