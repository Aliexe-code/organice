package main

import "core:fmt"
import "core:os"
import "core:path/filepath"
import "core:crypto/hash"
import "core:strings"
import "core:time"
import "core:encoding/json"
import "core:strconv"
import "core:slice"

// ANSI Color codes
RESET :: "\033[0m"
RED :: "\033[31m"
GREEN :: "\033[32m"
YELLOW :: "\033[33m"
BLUE :: "\033[34m"
MAGENTA :: "\033[35m"
CYAN :: "\033[36m"
BOLD :: "\033[1m"


Config :: struct {
	directory:         string,
	dry_run:           bool,
	duplicates_only:   bool,
	recursive:         bool,
	exclude_patterns:  [dynamic]string,
	min_size:          int,
	max_size:          int,
	by_date:           bool,
	interactive:       bool,
	delete_duplicates: bool,
	undo_mode:         bool,
	show_stats:        bool,
	use_colors:        bool,
	verbose:           bool,
	log_file:          string,
	config_file:       string,
	preserve_perms:    bool,
	custom_rules:      map[string]string,
}

File_Info :: struct {
	name:          string,
	path:          string,
	size:          int,
	modified_time: time.Time,
	extension:     string,
	category:      string,
	hash:          string,
	permissions:   os.File_Mode,
}

Operation_Log :: struct {
	timestamp:  string,
	operations: [dynamic]File_Operation,
}

File_Operation :: struct {
	from: string,
	to:   string,
	size: int,
}

Statistics :: struct {
	total_files:      int,
	total_size:       int,
	files_moved:      int,
	duplicates_found: int,
	categories:       map[string]int,
	category_sizes:   map[string]int,
}

Config_File :: struct {
	default_directory: string,
	recursive:         bool,
	use_colors:        bool,
	preserve_perms:    bool,
	verbose:           bool,
	exclude_patterns:  [dynamic]string,
	custom_categories: map[string][dynamic]string,
}

Error_Log :: struct {
	timestamp: string,
	action:    string,
	file_path: string,
	error_msg: string,
}

main :: proc() {
	config := parse_args()
	defer {
		delete(config.exclude_patterns)
		delete(config.custom_rules)
	}

	// Load config file if specified
	if config.config_file != "" {
		load_config_file(&config)
	}

	if config.directory == "" {
		print_usage()
		when ODIN_OS == .Windows {
			fmt.print("\nPress Enter to exit...")
			buf: [1]byte
			os.read(os.stdin, buf[:])
		}
		return
	}

	// Validate and sanitize directory path
	if !validate_directory(config.directory) {
		print_error("Invalid directory path: ", config.directory, config.use_colors)
		when ODIN_OS == .Windows {
			fmt.print("\nPress Enter to exit...")
			buf: [1]byte
			os.read(os.stdin, buf[:])
		}
		return
	}

	if !os.is_dir(config.directory) {
		print_error("Not a directory: ", config.directory, config.use_colors)
		when ODIN_OS == .Windows {
			fmt.print("\nPress Enter to exit...")
			buf: [1]byte
			os.read(os.stdin, buf[:])
		}
		return
	}

	if config.undo_mode {
		undo_last_operation(config)
		return
	}

	if config.duplicates_only {
		find_duplicates(config)
	} else {
		organize_directory(config)
	}
}

parse_args :: proc() -> Config {
	config: Config
	config.use_colors = true // Default to true
	config.max_size = max(int) // No limit by default
	config.preserve_perms = true // Default to preserving permissions
	config.custom_rules = make(map[string]string)

	if len(os.args) < 2 {
		return config
	}

	config.directory = os.args[1]

	for i := 2; i < len(os.args); i += 1 {
		arg := os.args[i]

		switch arg {
		case "--dry-run", "-d":
			config.dry_run = true
		case "--duplicates":
			config.duplicates_only = true
		case "--recursive", "-r":
			config.recursive = true
		case "--interactive", "-i":
			config.interactive = true
		case "--by-date":
			config.by_date = true
		case "--delete-duplicates":
			config.delete_duplicates = true
		case "--undo":
			config.undo_mode = true
		case "--stats", "-s":
			config.show_stats = true
		case "--no-color":
			config.use_colors = false
		case "--verbose", "-v":
			config.verbose = true
		case "--preserve-perms":
			config.preserve_perms = true
		case "--no-preserve-perms":
			config.preserve_perms = false
		case "--config", "-c":
			if i + 1 < len(os.args) {
				i += 1
				config.config_file = os.args[i]
			}
		case "--log":
			if i + 1 < len(os.args) {
				i += 1
				config.log_file = os.args[i]
			}
		case "--exclude", "-e":
			if i + 1 < len(os.args) {
				i += 1
				patterns := strings.split(os.args[i], ",")
				for pattern in patterns {
					append(&config.exclude_patterns, strings.trim_space(pattern))
				}
			}
		case "--min-size":
			if i + 1 < len(os.args) {
				i += 1
				config.min_size = parse_size(os.args[i])
			}
		case "--max-size":
			if i + 1 < len(os.args) {
				i += 1
				config.max_size = parse_size(os.args[i])
			}
		case "--category":
			if i + 2 < len(os.args) {
				i += 1
				ext := os.args[i]
				i += 1
				cat := os.args[i]
				config.custom_rules[ext] = cat
			}
		}
	}

	return config
}

parse_size :: proc(size_str: string) -> int {
	size_str := size_str
	multiplier := 1

	if strings.has_suffix(size_str, "KB") || strings.has_suffix(size_str, "kb") {
		multiplier = 1024
		size_str = size_str[:len(size_str)-2]
	} else if strings.has_suffix(size_str, "MB") || strings.has_suffix(size_str, "mb") {
		multiplier = 1024 * 1024
		size_str = size_str[:len(size_str)-2]
	} else if strings.has_suffix(size_str, "GB") || strings.has_suffix(size_str, "gb") {
		multiplier = 1024 * 1024 * 1024
		size_str = size_str[:len(size_str)-2]
	}

	value, ok := strconv.parse_int(size_str)
	if ok {
		return value * multiplier
	}
	return 0
}

organize_directory :: proc(config: Config) {
	files := list_files(config)
	defer delete(files)

	if len(files) == 0 {
		print_info("No files to organize.", config.use_colors)
		return
	}

	stats := compute_statistics(files)
	defer {
		delete(stats.categories)
		delete(stats.category_sizes)
	}

	if config.show_stats {
		print_statistics(stats, config.use_colors)
	}

	categories := make(map[string][dynamic]File_Info)
	defer {
		for _, files in categories {
			delete(files)
		}
		delete(categories)
	}

	for file in files {
		category := file.category
		if config.by_date {
			category = format_date_category(file.modified_time)
		}

		if category not_in categories {
			categories[category] = make([dynamic]File_Info)
		}
		append(&categories[category], file)
	}

	print_summary(files, categories, config.use_colors)

	if config.dry_run {
		print_dry_run(categories, config)
		return
	}

	// Confirm
	if !config.interactive {
		fmt.print("\nProceed with organization? (y/n): ")
		response: [64]byte
		n, _ := os.read(os.stdin, response[:])

		if n == 0 || (response[0] != 'y' && response[0] != 'Y') {
			print_info("Cancelled.", config.use_colors)
			return
		}
	}

	moved, operations := move_files(config.directory, categories, config)
	defer delete(operations)

	// Save operation log for undo
	save_operation_log(operations)

	print_success(fmt.tprintf("Successfully organized %d files!", moved), config.use_colors)
}

list_files :: proc(config: Config) -> [dynamic]File_Info {
	files := make([dynamic]File_Info)

	if config.recursive {
		list_files_recursive(config.directory, &files, config)
	} else {
		list_files_single(config.directory, &files, config)
	}

	return files
}

list_files_single :: proc(dir: string, files: ^[dynamic]File_Info, config: Config) {
	handle, open_err := os.open(dir)
	if open_err != os.ERROR_NONE {
		print_error(fmt.tprintf("Error opening directory: %v", open_err), "", config.use_colors)
		return
	}
	defer os.close(handle)

	file_infos, read_err := os.read_dir(handle, -1)
	if read_err != os.ERROR_NONE {
		print_error(fmt.tprintf("Error reading directory: %v", read_err), "", config.use_colors)
		return
	}
	defer delete(file_infos)

	for info in file_infos {
		if info.is_dir {
			continue
		}

		full_path := filepath.join({dir, info.name})

		// Check exclusion patterns
		if should_exclude(info.name, config.exclude_patterns) {
			continue
		}

		// Check size filters
		size := int(info.size)
		if size < config.min_size || size > config.max_size {
			continue
		}

		ext := filepath.ext(info.name)
		hash := compute_file_hash(full_path, config)

		file := File_Info {
			name          = info.name,
			size          = size,
			modified_time = info.modification_time,
			path          = full_path,
			extension     = ext,
			category      = categorize(ext, config),
			hash          = hash,
			permissions   = info.mode,
		}

		append(files, file)
	}
}

list_files_recursive :: proc(dir: string, files: ^[dynamic]File_Info, config: Config) {
	list_files_single(dir, files, config)

	handle, open_err := os.open(dir)
	if open_err != os.ERROR_NONE {
		return
	}
	defer os.close(handle)

	file_infos, read_err := os.read_dir(handle, -1)
	if read_err != os.ERROR_NONE {
		return
	}
	defer delete(file_infos)

	for info in file_infos {
		if info.is_dir {
			subdir := filepath.join({dir, info.name})
			list_files_recursive(subdir, files, config)
		}
	}
}

should_exclude :: proc(filename: string, patterns: [dynamic]string) -> bool {
	for pattern in patterns {
		if strings.contains(filename, pattern) {
			return true
		}
		// Simple wildcard matching
		if strings.has_prefix(pattern, "*") {
			suffix := pattern[1:]
			if strings.has_suffix(filename, suffix) {
				return true
			}
		}
	}
	return false
}

compute_file_hash :: proc(path: string, config: Config) -> string {
	data, ok := os.read_entire_file(path)
	if !ok {
		if config.verbose {
			print_warning(fmt.tprintf("Failed to read file for hashing: %s", path), config.use_colors)
		}
		log_error("hash_computation", path, "Failed to read file", config)
		return ""
	}
	defer delete(data)

	hash_value := hash.hash_bytes(.SHA256, data)
	defer delete(hash_value)
	return fmt.tprintf("%x", hash_value)
}

find_duplicates :: proc(config: Config) {
	files := list_files(config)
	defer delete(files)

	if len(files) == 0 {
		print_info("No files to check for duplicates.", config.use_colors)
		return
	}

	hash_map := make(map[string][dynamic]string)
	defer {
		for _, paths in hash_map {
			delete(paths)
		}
		delete(hash_map)
	}

	// Show progress
	for file, i in files {
		if file.hash not_in hash_map {
			hash_map[file.hash] = make([dynamic]string)
		}
		append(&hash_map[file.hash], file.path)

		if (i + 1) % 10 == 0 || i + 1 == len(files) {
			print_progress(i + 1, len(files), "Scanning", config.use_colors)
		}
	}
	fmt.println()

	duplicates_found := 0
	total_duplicate_size := 0

	for hash, paths in hash_map {
		if len(paths) > 1 {
			// Find file size
			file_size := 0
			for file in files {
				if file.hash == hash {
					file_size = file.size
					break
				}
			}

			print_warning(fmt.tprintf("\nDuplicate files (%s):", format_size(file_size)), config.use_colors)
			for path in paths {
				fmt.printf("  %s\n", path)
			}

			duplicates_found += 1
			total_duplicate_size += file_size * (len(paths) - 1)

			// Delete duplicates if requested
			if config.delete_duplicates {
				fmt.print("\nDelete duplicates (keep first)? (y/n): ")
				response: [64]byte
				n, _ := os.read(os.stdin, response[:])

				if n > 0 && (response[0] == 'y' || response[0] == 'Y') {
					for i := 1; i < len(paths); i += 1 {
						err := os.remove(paths[i])
						if err == os.ERROR_NONE {
							print_success(fmt.tprintf("Deleted: %s", paths[i]), config.use_colors)
						} else {
							print_error("Failed to delete: ", paths[i], config.use_colors)
						}
					}
				}
			}
		}
	}

	if duplicates_found == 0 {
		print_success("No duplicate files found.", config.use_colors)
	} else {
		print_info(fmt.tprintf("\nFound %d sets of duplicate files.", duplicates_found), config.use_colors)
		print_info(fmt.tprintf("Potential space savings: %s", format_size(total_duplicate_size)), config.use_colors)
	}
}

categorize :: proc(ext: string, config: Config) -> string {
	ext_lower := strings.to_lower(ext)

	// Check custom rules first
	if ext_lower in config.custom_rules {
		return config.custom_rules[ext_lower]
	}

	// Default categorization
	switch ext_lower {
	case ".jpg", ".jpeg", ".png", ".gif", ".bmp", ".svg", ".webp", ".ico", ".tiff", ".heic", ".raw":
		return "Images"
	case ".pdf", ".doc", ".docx", ".txt", ".md", ".rtf", ".odt", ".pptx", ".xlsx", ".csv", ".epub":
		return "Documents"
	case ".zip", ".tar", ".gz", ".rar", ".7z", ".bz2", ".jar", ".xz", ".tar.gz", ".tgz":
		return "Archives"
	case ".mp4", ".avi", ".mkv", ".mov", ".wmv", ".flv", ".webm", ".m4v", ".mpg", ".mpeg":
		return "Videos"
	case ".mp3", ".wav", ".flac", ".ogg", ".aac", ".m4a", ".wma", ".opus":
		return "Audio"
	case ".exe", ".dmg", ".app", ".deb", ".rpm", ".msi", ".appimage", ".bin":
		return "Applications"
	case ".py", ".go", ".rs", ".c", ".cpp", ".h", ".odin", ".js", ".ts", ".java", ".cs", ".rb", ".php", ".swift", ".kt":
		return "Code"
	case ".iso", ".img", ".vdi", ".vmdk", ".qcow2":
		return "Disk_Images"
	case ".json", ".xml", ".yaml", ".yml", ".toml", ".ini", ".cfg", ".conf":
		return "Configuration"
	case ".ttf", ".otf", ".woff", ".woff2":
		return "Fonts"
	case:
		return "Other"
	}
}

format_date_category :: proc(t: time.Time) -> string {
	year, month, day := time.date(t)
	return fmt.tprintf("%d-%02d", year, month)
}

move_files :: proc(dir: string, categories: map[string][dynamic]File_Info, config: Config) -> (int, [dynamic]File_Operation) {
	moved := 0
	duplicates := 0
	operations := make([dynamic]File_Operation)

	hash_map := make(map[string]string)
	defer delete(hash_map)

	total_files := 0
	for _, cat_files in categories {
		total_files += len(cat_files)
	}
	processed := 0

	for category, cat_files in categories {
		folder_path := filepath.join({dir, category})

		if !os.exists(folder_path) {
			err := os.make_directory(folder_path)
			if err != os.ERROR_NONE {
				print_error("Failed to create folder: ", folder_path, config.use_colors)
				continue
			}
		}

		for file in cat_files {
			processed += 1

			if config.interactive {
				fmt.printf("\nMove %s to %s? (y/n/q): ", file.name, category)
				response: [64]byte
				n, _ := os.read(os.stdin, response[:])

				if n > 0 && response[0] == 'q' {
					print_info("Cancelled remaining operations.", config.use_colors)
					return moved, operations
				}

				if n == 0 || (response[0] != 'y' && response[0] != 'Y') {
					continue
				}
			}

			dest := filepath.join({folder_path, file.name})

			// Check for content duplicates
			if file.hash in hash_map {
				print_warning(fmt.tprintf("Duplicate: %s (same as %s)", file.name, hash_map[file.hash]), config.use_colors)
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
				append(&operations, File_Operation{from = file.path, to = dest, size = file.size})
				
				// Preserve file permissions if requested
				if config.preserve_perms {
					chmod_err := os.chmod(dest, file.permissions)
					if chmod_err != os.ERROR_NONE && config.verbose {
						print_warning(fmt.tprintf("Failed to preserve permissions for: %s", file.name), config.use_colors)
					}
				}
				
				if config.verbose {
					print_info(fmt.tprintf("Moved: %s -> %s", file.name, category), config.use_colors)
				}
			} else {
				error_msg := fmt.tprintf("Failed to move %s: %v", file.name, err)
				print_error("", error_msg, config.use_colors)
				log_error("move_file", file.path, error_msg, config)
			}

			// Show progress
			print_progress(processed, total_files, "Moving", config.use_colors)
		}
	}
	fmt.println()

	if duplicates > 0 {
		print_warning(fmt.tprintf("Skipped %d duplicate files", duplicates), config.use_colors)
	}

	return moved, operations
}

save_operation_log :: proc(operations: [dynamic]File_Operation) {
	log_dir := filepath.join({os.get_env("HOME"), ".file-organizer"})
	if !os.exists(log_dir) {
		os.make_directory(log_dir)
	}

	log_path := filepath.join({log_dir, "last_operation.json"})

	op_log := Operation_Log {
		timestamp = fmt.tprintf("%v", time.now()),
		operations = operations,
	}

	data, err := json.marshal(op_log)
	if err != nil {
		return
	}
	defer delete(data)

	os.write_entire_file(log_path, data)
}

undo_last_operation :: proc(config: Config) {
	log_path := filepath.join({os.get_env("HOME"), ".file-organizer", "last_operation.json"})

	if !os.exists(log_path) {
		print_error("No operation log found.", "", config.use_colors)
		return
	}

	data, ok := os.read_entire_file(log_path)
	if !ok {
		print_error("Failed to read operation log.", "", config.use_colors)
		return
	}
	defer delete(data)

	op_log: Operation_Log
	err := json.unmarshal(data, &op_log)
	if err != nil {
		print_error("Failed to parse operation log.", "", config.use_colors)
		return
	}
	defer delete(op_log.operations)

	print_info(fmt.tprintf("Found %d operations from %s", len(op_log.operations), op_log.timestamp), config.use_colors)
	fmt.print("Undo these operations? (y/n): ")

	response: [64]byte
	n, _ := os.read(os.stdin, response[:])

	if n == 0 || (response[0] != 'y' && response[0] != 'Y') {
		print_info("Cancelled.", config.use_colors)
		return
	}

	undone := 0
	for op in op_log.operations {
		err := os.rename(op.to, op.from)
		if err == os.ERROR_NONE {
			undone += 1
		}
	}

	print_success(fmt.tprintf("Undone %d operations!", undone), config.use_colors)
	os.remove(log_path)
}

compute_statistics :: proc(files: [dynamic]File_Info) -> Statistics {
	stats: Statistics
	stats.categories = make(map[string]int)
	stats.category_sizes = make(map[string]int)

	for file in files {
		stats.total_files += 1
		stats.total_size += file.size
		stats.categories[file.category] += 1
		stats.category_sizes[file.category] += file.size
	}

	return stats
}

// Printing utilities with colors

print_success :: proc(msg: string, use_colors: bool) {
	if use_colors {
		fmt.printf("%s✓%s %s\n", GREEN, RESET, msg)
	} else {
		fmt.printf("✓ %s\n", msg)
	}
}

print_error :: proc(prefix: string, msg: string, use_colors: bool) {
	if use_colors {
		fmt.printf("%s✗ %s%s%s\n", RED, prefix, msg, RESET)
	} else {
		fmt.printf("✗ %s%s\n", prefix, msg)
	}
}

print_warning :: proc(msg: string, use_colors: bool) {
	if use_colors {
		fmt.printf("%s⚠%s %s\n", YELLOW, RESET, msg)
	} else {
		fmt.printf("⚠ %s\n", msg)
	}
}

print_info :: proc(msg: string, use_colors: bool) {
	if use_colors {
		fmt.printf("%sℹ%s %s\n", CYAN, RESET, msg)
	} else {
		fmt.printf("ℹ %s\n", msg)
	}
}

print_summary :: proc(files: [dynamic]File_Info, categories: map[string][dynamic]File_Info, use_colors: bool) {
	if use_colors {
		fmt.printf("\n%s%sFound %d files in %d categories:%s\n", BOLD, BLUE, len(files), len(categories), RESET)
	} else {
		fmt.printf("\nFound %d files in %d categories:\n", len(files), len(categories))
	}

	for category, cat_files in categories {
		total_size := 0
		for file in cat_files {
			total_size += file.size
		}

		if use_colors {
			fmt.printf("  %s📁 %-20s%s (%d files, %s)\n", CYAN, category, RESET, len(cat_files), format_size(total_size))
		} else {
			fmt.printf("  📁 %-20s (%d files, %s)\n", category, len(cat_files), format_size(total_size))
		}
	}
}

print_statistics :: proc(stats: Statistics, use_colors: bool) {
	if use_colors {
		fmt.printf("\n%s%s=== Statistics ===%s\n", BOLD, MAGENTA, RESET)
	} else {
		fmt.println("\n=== Statistics ===")
	}

	fmt.printf("Total files: %d\n", stats.total_files)
	fmt.printf("Total size: %s\n", format_size(stats.total_size))

	// Sort categories by size
	Cat_Size :: struct {
		name: string,
		size: int,
	}

	cat_sizes := make([dynamic]Cat_Size)
	defer delete(cat_sizes)

	for cat, size in stats.category_sizes {
		append(&cat_sizes, Cat_Size{cat, size})
	}

	slice.sort_by(cat_sizes[:], proc(a, b: Cat_Size) -> bool {
		return a.size > b.size
	})

	fmt.println("\nBy category (largest first):")
	for cat in cat_sizes {
		fmt.printf("  %-15s: %5d files, %10s\n", cat.name, stats.categories[cat.name], format_size(cat.size))
	}
	fmt.println()
}

print_dry_run :: proc(categories: map[string][dynamic]File_Info, config: Config) {
	print_warning("[DRY RUN - no files will be moved]", config.use_colors)
	for category, files in categories {
		fmt.printf("\nWould create: %s/\n", category)
		for file in files {
			fmt.printf("  Move: %s -> %s/%s\n", file.name, category, file.name)
		}
	}
}

print_progress :: proc(current: int, total: int, action: string, use_colors: bool) {
	percent := (current * 100) / total
	bar_width := 30
	filled := (percent * bar_width) / 100

	bar: strings.Builder
	defer strings.builder_destroy(&bar)

	strings.write_byte(&bar, '[')
	for i := 0; i < bar_width; i += 1 {
		if i < filled {
			strings.write_string(&bar, "█")
		} else {
			strings.write_string(&bar, "░")
		}
	}
	strings.write_byte(&bar, ']')

	bar_str := strings.to_string(bar)

	if use_colors {
		fmt.printf("\r%s%s: %s %3d%% (%d/%d)%s", CYAN, action, bar_str, percent, current, total, RESET)
	} else {
		fmt.printf("\r%s: %s %3d%% (%d/%d)", action, bar_str, percent, current, total)
	}
}

format_size :: proc(bytes: int) -> string {
	kb := f64(bytes) / 1024
	mb := kb / 1024
	gb := mb / 1024

	if gb >= 1 {
		return fmt.tprintf("%.2f GB", gb)
	} else if mb >= 1 {
		return fmt.tprintf("%.2f MB", mb)
	} else if kb >= 1 {
		return fmt.tprintf("%.2f KB", kb)
	} else {
		return fmt.tprintf("%d B", bytes)
	}
}

// Validate and sanitize directory path
validate_directory :: proc(dir: string) -> bool {
	// Check for null or empty
	if dir == "" {
		return false
	}
	
	// Check for invalid characters (basic security check)
	invalid_chars := []string{"\x00", "\n", "\r"}
	for char in invalid_chars {
		if strings.contains(dir, char) {
			return false
		}
	}
	
	// Check path length (prevent extremely long paths)
	if len(dir) > 4096 {
		return false
	}
	
	return true
}

// Load configuration from file
load_config_file :: proc(config: ^Config) {
	if !os.exists(config.config_file) {
		print_warning(fmt.tprintf("Config file not found: %s", config.config_file), config.use_colors)
		return
	}
	
	data, ok := os.read_entire_file(config.config_file)
	if !ok {
		print_error("Failed to read config file: ", config.config_file, config.use_colors)
		return
	}
	defer delete(data)
	
	cfg_file: Config_File
	err := json.unmarshal(data, &cfg_file)
	if err != nil {
		print_error("Failed to parse config file: ", config.config_file, config.use_colors)
		return
	}
	defer {
		delete(cfg_file.exclude_patterns)
		for _, patterns in cfg_file.custom_categories {
			delete(patterns)
		}
		delete(cfg_file.custom_categories)
	}
	
	// Apply config file settings (command line args take precedence)
	if config.directory == "" && cfg_file.default_directory != "" {
		config.directory = cfg_file.default_directory
	}
	
	if !config.recursive && cfg_file.recursive {
		config.recursive = cfg_file.recursive
	}
	
	if !config.verbose && cfg_file.verbose {
		config.verbose = cfg_file.verbose
	}
	
	if !config.preserve_perms && cfg_file.preserve_perms {
		config.preserve_perms = cfg_file.preserve_perms
	}
	
	// Merge exclude patterns
	for pattern in cfg_file.exclude_patterns {
		append(&config.exclude_patterns, pattern)
	}
	
	// Load custom categories
	for category, extensions in cfg_file.custom_categories {
		for ext in extensions {
			config.custom_rules[ext] = category
		}
	}
	
	if config.verbose {
		print_success(fmt.tprintf("Loaded config from: %s", config.config_file), config.use_colors)
	}
}

// Log errors to file
log_error :: proc(action: string, file_path: string, error_msg: string, config: Config) {
	if config.log_file == "" {
		return
	}
	
	log_entry := Error_Log {
		timestamp = fmt.tprintf("%v", time.now()),
		action = action,
		file_path = file_path,
		error_msg = error_msg,
	}
	
	// Append to log file
	log_line := fmt.tprintf("[%s] %s | %s | %s\n", log_entry.timestamp, log_entry.action, log_entry.file_path, log_entry.error_msg)
	
	// Try to append to existing file or create new one
	handle, err := os.open(config.log_file, os.O_WRONLY | os.O_CREATE | os.O_APPEND, 0o644)
	if err != os.ERROR_NONE {
		return
	}
	defer os.close(handle)
	
	os.write_string(handle, log_line)
}

// Save default configuration file
save_default_config :: proc(path: string) -> bool {
	default_config := Config_File {
		recursive = true,
		use_colors = true,
		preserve_perms = true,
		verbose = false,
	}
	
	data, err := json.marshal(default_config, {pretty = true})
	if err != nil {
		return false
	}
	defer delete(data)
	
	ok := os.write_entire_file(path, data)
	return ok
}

print_usage :: proc() {
	fmt.println("📁 File Organizer v2.1")
	fmt.println("═════════════════════════")
	fmt.println("\nUsage:")
	fmt.println("  organize <directory> [options]")
	fmt.println("\nOptions:")
	fmt.println("  -d, --dry-run              Preview without moving files")
	fmt.println("  -r, --recursive            Scan subdirectories recursively")
	fmt.println("  -i, --interactive          Confirm each file move")
	fmt.println("  -s, --stats                Show detailed statistics")
	fmt.println("  -v, --verbose              Enable verbose output")
	fmt.println("  -c, --config <file>        Load configuration from file")
	fmt.println("  -e, --exclude <patterns>   Exclude files (comma-separated)")
	fmt.println("  --by-date                  Organize by date (YYYY-MM)")
	fmt.println("  --duplicates               Find and show duplicate files")
	fmt.println("  --delete-duplicates        Delete duplicate files (interactive)")
	fmt.println("  --undo                     Undo last organization operation")
	fmt.println("  --no-color                 Disable colored output")
	fmt.println("  --min-size <size>          Minimum file size (e.g., 1MB)")
	fmt.println("  --max-size <size>          Maximum file size (e.g., 100MB)")
	fmt.println("  --log <file>               Log errors to specified file")
	fmt.println("  --preserve-perms           Preserve file permissions (default)")
	fmt.println("  --no-preserve-perms        Don't preserve file permissions")
	fmt.println("  --category <ext> <cat>     Set custom category for extension")
	fmt.println("\nFeatures:")
	fmt.println("  • Automatic categorization by file extension")
	fmt.println("  • Custom categorization rules support")
	fmt.println("  • Configuration file support (JSON)")
	fmt.println("  • File permission preservation")
	fmt.println("  • Error logging to file")
	fmt.println("  • Recursive directory scanning")
	fmt.println("  • Duplicate detection using SHA256 hashing")
	fmt.println("  • Date-based organization")
	fmt.println("  • File size filtering")
	fmt.println("  • Exclude patterns support")
	fmt.println("  • Undo functionality")
	fmt.println("  • Interactive mode")
	fmt.println("  • Progress indicators")
	fmt.println("  • Colorized output")
	fmt.println("  • Detailed statistics")
	fmt.println("  • Verbose logging")
	fmt.println("  • Input validation and sanitization")
	fmt.println("\nDefault Categories:")
	fmt.println("  Images, Documents, Archives, Videos, Audio, Applications,")
	fmt.println("  Code, Disk_Images, Configuration, Fonts, Other")
	fmt.println("\nExamples:")
	fmt.println("  organize ~/Downloads")
	fmt.println("  organize ~/Desktop --dry-run --stats")
	fmt.println("  organize ~/Pictures --duplicates")
	fmt.println("  organize ~/Downloads --recursive --min-size 1MB")
	fmt.println("  organize ~/Documents --by-date --exclude '*.tmp,*.log'")
	fmt.println("  organize ~/Downloads --interactive --verbose")
	fmt.println("  organize ~/Downloads --undo")
	fmt.println("  organize ~/Files --config ~/.organizer.json --log ~/errors.log")
	fmt.println("  organize ~/Code --category .tsx Code --category .jsx Code")
	fmt.println("\nConfig File Format (JSON):")
	fmt.println("  {")
	fmt.println("    \"recursive\": true,")
	fmt.println("    \"use_colors\": true,")
	fmt.println("    \"preserve_perms\": true,")
	fmt.println("    \"verbose\": false,")
	fmt.println("    \"exclude_patterns\": [\"*.tmp\", \"*.log\"],")
	fmt.println("    \"custom_categories\": {")
	fmt.println("      \"MyCategory\": [\".custom1\", \".custom2\"]")
	fmt.println("    }")
	fmt.println("  }")
}
