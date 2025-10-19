package main

import "core:fmt"
import "core:os"
import "core:path/filepath"
import "core:crypto/hash"
import "core:strings"


File_Info :: struct {
	name:          string,
	path:          string,
	size:          int,
	modified_date: string,
	extension:     string,
	category:      string,
	hash:          string,  // For duplicate detection
}

main :: proc() {
	if len(os.args) < 2 {
		print_usage()
		when ODIN_OS == .Windows {
			fmt.print("\nPress Enter to exit...")
			buf: [1]byte
			os.read(os.stdin, buf[:])
		}
		return
	}
	dir := os.args[1]
	dry_run := len(os.args) > 2 && os.args[2] == "--dry-run"
	duplicates_only := len(os.args) > 2 && os.args[2] == "--duplicates"
	if !os.is_dir(dir) {
		fmt.println("Error : Not a directory.")
		when ODIN_OS == .Windows {
			fmt.print("\nPress Enter to exit...")
			buf: [1]byte
			os.read(os.stdin, buf[:])
		}
		return
	}

	if duplicates_only {
		find_duplicates(dir)
	} else {
		organize_directory(dir, dry_run)
	}
}


organize_directory :: proc(dir: string, dry_run: bool) {
	files := list_files(dir)
	defer delete(files)

	if len(files) == 0 {
		fmt.println("No files to organize.")
		return
	}

	categories := make(map[string][dynamic]File_Info)
	defer {
		for _, files in categories {
			delete(files)
		}
		delete(categories)
	}

	for file in files {
		if file.category not_in categories {
			categories[file.category] = make([dynamic]File_Info)

		}
		append(&categories[file.category], file)
	}

	fmt.printf("\n Found %d files in %d categories:\n", len(files), len(categories))
	for category, files in categories {
		fmt.printf("  📁 %-15s (%d files)\n", category, len(files))
	}
	if dry_run {
		fmt.println("\n[DRY RUN - no files were moved, No files were moved.]")
		for category, files in categories {
			fmt.printf("\n Would create: %s/\n", category)
			for file in files {
				fmt.printf("  Move: %s -> %s/%s\n", file.name, category, file.name)
			}
		}
		return
	}


	// Confirm
	fmt.print("\nProceed with organization? (y/n): ")
	response: [64]byte
	n, _ := os.read(os.stdin, response[:])

	if n > 0 && (response[0] == 'y' || response[0] == 'Y') {
		moved := move_files(dir, categories)
		fmt.printf("\n✓ Successfully organized %d files!\n", moved)
	} else {
		fmt.println("Cancelled.")
	}
}

list_files :: proc(dir: string) -> [dynamic]File_Info {
	files := make([dynamic]File_Info)

	handle, open_err := os.open(dir)
	if open_err != os.ERROR_NONE {
		fmt.println("Error opening directory:", open_err)
		return files
	}
	defer os.close(handle)

	file_infos, read_err := os.read_dir(handle, -1)
	if read_err != os.ERROR_NONE {
		fmt.println("Error reading directory:", read_err)
		return files
	}
	defer delete(file_infos)

	for info in file_infos {
		if info.is_dir {
			continue
		}

		full_path := filepath.join({dir, info.name})
		ext := filepath.ext(info.name)

		hash := compute_file_hash(full_path)
		file := File_Info {
			name          = info.name,
			size          = int(info.size),
			modified_date = fmt.tprintf("%v", info.modification_time),
			path          = full_path,
			extension     = ext,
			category      = categorize(ext),
			hash          = hash,
		}

		append(&files, file)
	}

	return files
}

compute_file_hash :: proc(path: string) -> string {
	data, ok := os.read_entire_file(path)
	if !ok {
		return ""
	}
	defer delete(data)

	hash_value := hash.hash_bytes(.SHA256, data)
	defer delete(hash_value)
	return fmt.tprintf("%x", hash_value)
}

find_duplicates :: proc(dir: string) {
	files := list_files(dir)
	defer delete(files)

	if len(files) == 0 {
		fmt.println("No files to check for duplicates.")
		return
	}

	hash_map := make(map[string][dynamic]string) // hash -> list of file paths
	defer {
		for _, paths in hash_map {
			delete(paths)
		}
		delete(hash_map)
	}

	for file in files {
		if file.hash not_in hash_map {
			hash_map[file.hash] = make([dynamic]string)
		}
		append(&hash_map[file.hash], file.path)
	}

	duplicates_found := 0
	for hash, paths in hash_map {
		if len(paths) > 1 {
			fmt.printf("Duplicate files (hash: %s):\n", hash)
			for path in paths {
				fmt.printf("  %s\n", path)
			}
			fmt.println()
			duplicates_found += 1
		}
	}

	if duplicates_found == 0 {
		fmt.println("No duplicate files found.")
	} else {
		fmt.printf("Found %d sets of duplicate files.\n", duplicates_found)
	}
}

categorize :: proc(ext: string) -> string {
	ext_lower := strings.to_lower(ext)

	switch ext_lower {
	case ".jpg", ".jpeg", ".png", ".gif", ".bmp", ".svg", ".webp":
		return "Images"
	case ".pdf", ".doc", ".docx", ".txt", ".md", ".rtf", ".odt", ".pptx":
		return "Documents"
	case ".zip", ".tar", ".gz", ".rar", ".7z", ".bz2", ".jar":
		return "Archives"
	case ".mp4", ".avi", ".mkv", ".mov", ".wmv", ".flv":
		return "Videos"
	case ".mp3", ".wav", ".flac", ".ogg", ".aac", ".m4a":
		return "Audio"
	case ".exe", ".dmg", ".app", ".deb", ".rpm", ".msi":
		return "Applications"
	case ".py", ".go", ".rs", ".c", ".cpp", ".h", ".odin", ".js", ".ts":
		return "Code"
	case:
		return "Other"
	}
}

move_files :: proc(dir: string, categories: map[string][dynamic]File_Info) -> int {
	moved := 0
	duplicates := 0

	// Create a map to track hashes for duplicate detection
	hash_map := make(map[string]string) // hash -> first file path
	defer delete(hash_map)

	for category, cat_files in categories {
		folder_path := filepath.join({dir, category})

		// Create category folder if it doesn't exist
		if !os.exists(folder_path) {
			err := os.make_directory(folder_path)
			if err != os.ERROR_NONE {
				fmt.printf("Failed to create folder: %s\n", folder_path)
				continue
			}
		}

		// Move files, handling duplicates
		for file in cat_files {
			dest := filepath.join({folder_path, file.name})

			// Check for content duplicates using hash
			if file.hash in hash_map {
				fmt.printf("Duplicate found: %s (same as %s)\n", file.name, hash_map[file.hash])
				duplicates += 1
				continue
			}
			hash_map[file.hash] = file.path

			// Handle name conflicts
			if os.exists(dest) {
				base := strings.trim_suffix(file.name, file.extension)
				counter := 1
				for {
					new_dest := filepath.join({folder_path, fmt.tprintf("%s (%d)%s", base, counter, file.extension)})
					if !os.exists(new_dest) {
						dest = new_dest
						break
					}
					counter += 1
				}
			}

			err := os.rename(file.path, dest)
			if err == os.ERROR_NONE {
				moved += 1
			} else {
				fmt.printf("Failed to move: %s\n", file.name)
			}
		}
	}

	if duplicates > 0 {
		fmt.printf("\nSkipped %d duplicate files\n", duplicates)
	}
	return moved
}

print_usage :: proc() {
	fmt.println("📁 File Organizer")
	fmt.println("═════════════════")
	fmt.println("Usage:")
	fmt.println("  organize <directory> - Organize files by category")
	fmt.println("  organize <directory> --dry-run - Preview without moving files")
	fmt.println("  organize <directory> --duplicates - Find and show duplicate files")
	fmt.println("\nFeatures:")
	fmt.println("  • Automatic categorization by file extension")
	fmt.println("  • Duplicate file detection using SHA256 hashing")
	fmt.println("  • Safe duplicate handling (skips identical files)")
	fmt.println("  • Dry-run mode for previewing changes")
	fmt.println("\nExample:")
	fmt.println("  organize ~/Downloads")
	fmt.println("  organize ~/Desktop --dry-run")
	fmt.println("  organize ~/Pictures --duplicates")
}

