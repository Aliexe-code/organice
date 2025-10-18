package main

import "core:fmt"
import "core:os"
import "core:path/filepath"
import "core:strings"


File_Info :: struct {
	name:          string,
	path:          string,
	size:          int,
	modified_date: string,
	extension:     string,
	category:      string,
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
	if !os.is_dir(dir) {
		fmt.println("Error : Not a directory.")
		when ODIN_OS == .Windows {
			fmt.print("\nPress Enter to exit...")
			buf: [1]byte
			os.read(os.stdin, buf[:])
		}
		return
	}

	organize_directory(dir, dry_run)
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

		file := File_Info {
			name          = info.name,
			size          = int(info.size),
			modified_date = fmt.tprintf("%v", info.modification_time),
			path          = full_path,
			extension     = ext,
			category      = categorize(ext),
		}

		append(&files, file)
	}

	return files
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

		// Move files
		for file in cat_files {
			dest := filepath.join({folder_path, file.name})

			// Handle duplicate names
			if os.exists(dest) {
				base := strings.trim_suffix(file.name, file.extension)
				dest = filepath.join({folder_path, fmt.tprintf("%s_copy%s", base, file.extension)})
			}

			err := os.rename(file.path, dest)
			if err == os.ERROR_NONE {
				moved += 1
			} else {
				fmt.printf("Failed to move: %s\n", file.name)
			}
		}
	}

	return moved
}

print_usage :: proc() {
	fmt.println("📁 File Organizer")
	fmt.println("═════════════════")
	fmt.println("Usage:")
	fmt.println("  organize <directory>- Organize files by category")
	fmt.println("  organize <directory> --dry-run - Preview without moving files")
	fmt.println("\nExample:")
	fmt.println("  organize ~/Downloads")
	fmt.println("  organize ~/Desktop --dry-run")
}
