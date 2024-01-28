package main

import (
	"crypto/md5"
	"encoding/json"
	"flag"
	"fmt"
	"io"
	"log"
	"os"
	"path/filepath"
)

var scanDir string

func calculateFileMD5(filePath string) (string, error) {
	// 打开文件
	file, err := os.Open(filePath)
	if err != nil {
		return "", fmt.Errorf("error opening file: %v", err)
	}
	defer file.Close()

	// 创建一个MD5哈希对象
	hash := md5.New()

	// 将文件内容拷贝到哈希对象中
	_, err = io.Copy(hash, file)
	if err != nil {
		return "", fmt.Errorf("error copying file to hash: %v", err)
	}

	// 计算MD5值
	hashInBytes := hash.Sum(nil)
	// 将MD5值转换为16进制字符串
	md5String := fmt.Sprintf("%x", hashInBytes)

	return md5String, nil
}

func main() {
	flag.StringVar(&scanDir, "d", "dir", "frp build dir")
	flag.Parse()

	files, err := os.ReadDir(scanDir)
	if err != nil {
		fmt.Println("Error reading directory:", err, scanDir)
		return
	}

	m := make(map[string]string)
	fmt.Println("Files in", scanDir, ":")
	for _, file := range files {
		if file.IsDir() {
			fmt.Println("Directory:", file.Name())
		} else {
			hash, err := calculateFileMD5(filepath.Join(scanDir, file.Name()))
			if err != nil {
				log.Printf("md5 failed: %s", err.Error())
			} else {
				if file.Name()[0] != '.' {
					m[fmt.Sprintf("%s_md5", file.Name())] = hash
					log.Printf("%s md5 = %s", file.Name(), hash)
				}
			}
		}
	}

	// 将 map 转换为 JSON 格式
	jsonData, err := json.MarshalIndent(m, "", "    ")
	if err != nil {
		fmt.Println("Error encoding JSON:", err)
		return
	}

	fmt.Println(string(jsonData))
}
