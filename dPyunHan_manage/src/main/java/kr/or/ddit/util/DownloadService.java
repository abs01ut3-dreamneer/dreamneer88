package kr.or.ddit.util;

import java.io.ByteArrayOutputStream;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import kr.or.ddit.vo.FileDetailVO;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class DownloadService {
    // ========== 상수 정의 ==========
    private static final String CHARSET = "UTF-8";
    private static final String ZIP_CONTENT_TYPE = "application/zip";
    private static final String ZIP_FILENAME = "files.zip";

    @Autowired
    private UploadService uploadService;

    // 파일 정보 가져오기
    private FileDetailVO getFileOrThrow(long fileGroupSn, int fileNo) {
        FileDetailVO fileDetailVO = uploadService.getFileDetail(fileGroupSn, fileNo);
        if (fileDetailVO == null) {
            throw new IllegalArgumentException("파일을 찾을 수 없습니다: " + fileGroupSn + "/" + fileNo);
        }
        return fileDetailVO;
    }
    
    //파일명 URL 인코딩
    private String encodeFileName(String fileName) {
        try {
            return URLEncoder.encode(fileName, CHARSET).replaceAll("\\+", "%20");
        } catch (Exception e) {
            log.error("파일명 인코딩 실패", e);
            return "download";
        }
    }

    // 다운로드 응답 헤더 설정
    private ResponseEntity.BodyBuilder setDownloadHeaders(String fileName, String contentType) {
        String encodedFileName = encodeFileName(fileName);
        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION, 
                    "attachment; filename*=" + CHARSET + "''" + encodedFileName)
                .header(HttpHeaders.CONTENT_TYPE, contentType);
    }

    // 단일 파일 다운로드
    public ResponseEntity<Resource> downloadFile(long fileGroupSn, int fileNo) {
        try {
            FileDetailVO fileDetailVO = getFileOrThrow(fileGroupSn, fileNo);
            return createFileResponse(fileDetailVO);
            
        } catch (IllegalArgumentException e) {
            log.error("파일 정보 없음", e);
            return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
            
        } catch (FileNotFoundException e) {
            log.error("파일 없음: {}/{}", fileGroupSn, fileNo, e);
            return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
            
        } catch (IOException e) {
            log.error("파일 I/O 오류: {}/{}", fileGroupSn, fileNo, e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
            
        } catch (Exception e) {
            log.error("예상치 못한 오류", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
    
    // 선택된 파일 다운로드
    public ResponseEntity<Resource> downloadSelected(List<Long> fileGroupSnList, List<Integer> fileNoList) {
        try {
            // 입력값 검증
            if (fileGroupSnList == null || fileGroupSnList.isEmpty()) {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).build();
            }

            // 파일 1개 선택
            if (fileGroupSnList.size() == 1 && fileNoList.size() == 1) {
                return downloadFile(fileGroupSnList.get(0), fileNoList.get(0));
            }

            // 여러 파일: ZIP으로 압축
            return downloadFilesAsZip(fileGroupSnList, fileNoList);
            
        } catch (Exception e) {
            log.error("선택 다운로드 오류", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
    
    // 전체 파일 다운로드
    public ResponseEntity<Resource> downloadAll(long fileGroupSn) {
        try {
            List<FileDetailVO> fileDetailVOList = uploadService.getFileDetailVOList(fileGroupSn);

            if (fileDetailVOList == null || fileDetailVOList.isEmpty()) {
                log.warn("다운로드할 파일 없음: {}", fileGroupSn);
                return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
            }

            // 파일이 1개만 있으면 단일 파일로 다운로드
            if (fileDetailVOList.size() == 1) {
                return createFileResponse(fileDetailVOList.get(0));
            }

            // 다중 파일은 ZIP으로 압축
            List<Long> fileGroupSnList = new ArrayList<>();
            List<Integer> fileNoList = new ArrayList<>();

            for (FileDetailVO file : fileDetailVOList) {
                fileGroupSnList.add(fileGroupSn);
                fileNoList.add(file.getFileNo());
            }

            return downloadFilesAsZip(fileGroupSnList, fileNoList);
            
        } catch (Exception e) {
            log.error("전체 다운로드 오류", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }


    // 파일 미리보기 
    public ResponseEntity<?> previewFile(long fileGroupSn, int fileNo) {
        try {
            FileDetailVO fileDetailVO = getFileOrThrow(fileGroupSn, fileNo);

            Path filePath = Paths.get(fileDetailVO.getFileAbsltStrelc());
            if (!Files.exists(filePath)) {
                log.warn("파일 없음: {}", filePath);
                return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
            }
            
            try (FileInputStream fis = new FileInputStream(filePath.toFile())) {
                byte[] fileContent = fis.readAllBytes();

                return ResponseEntity.ok()
                        .contentType(MediaType.APPLICATION_PDF)
                        .header(HttpHeaders.CONTENT_DISPOSITION,
                                "inline; filename=\"" + fileDetailVO.getFileOrginlNm() + "\"")
                        .body(new ByteArrayResource(fileContent));
            }

        } catch (IllegalArgumentException e) {
            log.error("파일 정보 없음", e);
            return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
            
        } catch (FileNotFoundException e) {
            log.error("파일을 찾을 수 없습니다: {}/{}", fileGroupSn, fileNo, e);
            return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
            
        } catch (IOException e) {
            log.error("파일 처리 오류: {}/{}", fileGroupSn, fileNo, e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
            
        } catch (Exception e) {
            log.error("예상치 못한 오류", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

   
    //  ZIP 파일로 압축해서 다운로드
    private ResponseEntity<Resource> downloadFilesAsZip(List<Long> fileGroupSnList, List<Integer> fileNoList) {
        try {
            ByteArrayOutputStream baos = new ByteArrayOutputStream();

            try (ZipOutputStream zos = new ZipOutputStream(baos)) {
                for (int i = 0; i < fileGroupSnList.size(); i++) {
                    try {
                        addFileToZip(zos, fileGroupSnList.get(i), fileNoList.get(i));
                    } catch (Exception e) {
                        log.warn("ZIP 엔트리 추가 실패: {}/{}", fileGroupSnList.get(i), fileNoList.get(i), e);
                    }
                }
            } 

            if (baos.size() == 0) {
                log.warn("압축된 파일 없음");
                return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
            }

            ByteArrayResource resource = new ByteArrayResource(baos.toByteArray());
            return setDownloadHeaders(ZIP_FILENAME, ZIP_CONTENT_TYPE)
                    .contentLength(baos.size())
                    .body(resource);
                    
        } catch (IOException e) {
            log.error("ZIP 생성 오류", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    // ZIP에 파일 엔트리 추가
    private void addFileToZip(ZipOutputStream zos, long fileGroupSn, int fileNo) throws IOException {
        FileDetailVO fileDetailVO = uploadService.getFileDetail(fileGroupSn, fileNo);
        if (fileDetailVO == null) {
            log.debug("파일 정보 없음: {}/{}", fileGroupSn, fileNo);
            return;
        }

        Path filePath = Paths.get(fileDetailVO.getFileAbsltStrelc());
        if (!Files.exists(filePath)) {
            log.warn("파일 없음: {}", filePath);
            return;
        }

        try {
            ZipEntry zipEntry = new ZipEntry(fileDetailVO.getFileOrginlNm());
            zos.putNextEntry(zipEntry);
            Files.copy(filePath, zos);
            zos.closeEntry();
            log.debug("ZIP 엔트리 추가 성공: {}", fileDetailVO.getFileOrginlNm());
        } catch (IOException e) {
            log.error("ZIP 엔트리 추가 실패: {}", fileDetailVO.getFileOrginlNm(), e);
            throw e;
        }
    }

    // 단일 파일 응답 생성
    private ResponseEntity<Resource> createFileResponse(FileDetailVO fileDetailVO) throws IOException {
        Path filePath = Paths.get(fileDetailVO.getFileAbsltStrelc());

        // 파일 존재 확인
        if (!Files.exists(filePath)) {
            throw new FileNotFoundException("파일 없음: " + filePath);
        }

        Resource resource = new FileSystemResource(filePath);

        return setDownloadHeaders(fileDetailVO.getFileOrginlNm(), fileDetailVO.getFileMime())
                .body(resource);
    }
}
