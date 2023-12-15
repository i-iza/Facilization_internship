package com.ExcelFileUpload.repository;

import com.ExcelFileUpload.entity.ExcelFile;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface ExcelFileRepository extends JpaRepository<ExcelFile, Long> {
    Optional<ExcelFile> findByFileName(String filename);
}
