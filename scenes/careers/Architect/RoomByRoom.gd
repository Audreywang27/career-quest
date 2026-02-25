extends Node2D

const GRID_SIZE    : int = 6
const BOX_ROWS     : int = 2
const BOX_COLS     : int = 3
const REMOVE_CLUES : int = 18

@export var c_cell            : Color = Color(0.200, 0.340, 0.230, 1.0)
@export var c_cell_alt        : Color = Color(0.245, 0.395, 0.270, 1.0)
@export var c_selected        : Color = Color(1.0,   1.0,   0.6,   0.30)
@export var c_highlight       : Color = Color(1.0,   1.0,   1.0,   0.07)
@export var c_error           : Color = Color(1.0,   0.3,   0.3,   0.35)
@export var c_grid_thin       : Color = Color(1.0,   1.0,   1.0,   0.25)
@export var c_grid_thick      : Color = Color(1.0,   1.0,   1.0,   0.70)
@export var c_num_given       : Color = Color(1.0,   1.0,   1.0,   1.0 )
@export var c_num_player      : Color = Color(0.75,  0.95,  1.0,   1.0 )
@export var c_num_error       : Color = Color(1.0,   0.50,  0.50,  1.0 )
@export var c_dust            : Color = Color(1.0,   1.0,   1.0,   0.022)
@export var grid_size_ratio   : float = 0.72
@export var line_thin_width   : float = 1.2
@export var line_thick_width  : float = 3.5
@export var font_size_given   : float = 0.55
@export var font_size_player  : float = 0.50
@export var chalk_smear_alpha : float = 0.28
@export var dust_count        : int   = 60

var solution  : Array[Array] = []
var puzzle    : Array[Array] = []
var player    : Array[Array] = []
var given     : Array[Array] = []
var sel_row   : int   = -1
var sel_col   : int   = -1
var won       : bool  = false

var cell_size : float = 0.0
var grid_x    : float = 0.0
var grid_y    : float = 0.0
var grid_w    : float = 0.0
var grid_h    : float = 0.0

var font : Font = preload("res://Assets/Fonts/FrederickatheGreat-Regular.ttf")

@onready var hud_label : Label          = $UI/HudLabel
@onready var win_panel : PanelContainer = $UI/WinPanel


func _ready() -> void:
	var screen : Vector2 = get_viewport().get_visible_rect().size
	grid_w    = min(screen.x, screen.y) * grid_size_ratio
	cell_size = floor(grid_w / GRID_SIZE)
	grid_w    = cell_size * GRID_SIZE
	grid_h    = grid_w
	grid_x    = floor((screen.x - grid_w) / 2.0)
	grid_y    = floor((screen.y - grid_h) / 2.0)
	_new_game()


func _new_game() -> void:
	won     = false
	sel_row = -1
	sel_col = -1
	solution = _make_empty_grid()
	_fill_grid(solution)
	puzzle = _copy_grid(solution)
	_remove_cells(puzzle, REMOVE_CLUES)
	given  = []
	player = []
	for r : int in range(GRID_SIZE):
		given.append([])
		player.append([])
		for c : int in range(GRID_SIZE):
			given[r].append(puzzle[r][c] != 0)
			player[r].append(0)
	win_panel.visible = false
	hud_label.visible = true
	queue_redraw()
	

func _make_empty_grid() -> Array[Array]:
	var g : Array[Array] = []
	for r : int in range(GRID_SIZE):
		g.append([])
		for _c : int in range(GRID_SIZE):
			g[r].append(0)
	return g


func _copy_grid(g: Array[Array]) -> Array[Array]:
	var copy : Array[Array] = []
	for r : int in range(GRID_SIZE):
		copy.append(g[r].duplicate())
	return copy


func _fill_grid(g: Array[Array]) -> bool:
	for r : int in range(GRID_SIZE):
		for c : int in range(GRID_SIZE):
			if g[r][c] != 0:
				continue
			var nums : Array[int] = [1, 2, 3, 4, 5, 6]
			nums.shuffle()
			for n : int in nums:
				if _is_valid(g, r, c, n):
					g[r][c] = n
					if _fill_grid(g):
						return true
					g[r][c] = 0
			return false
	return true


func _is_valid(g: Array[Array], row: int, col: int, num: int) -> bool:
	for i : int in range(GRID_SIZE):
		if g[row][i] == num or g[i][col] == num:
			return false
	var box_r : int = (row / BOX_ROWS) * BOX_ROWS
	var box_c : int = (col / BOX_COLS) * BOX_COLS
	for r : int in range(box_r, box_r + BOX_ROWS):
		for c : int in range(box_c, box_c + BOX_COLS):
			if g[r][c] == num:
				return false
	return true


func _remove_cells(g: Array[Array], count: int) -> void:
	var cells : Array[Vector2i] = []
	for r : int in range(GRID_SIZE):
		for c : int in range(GRID_SIZE):
			cells.append(Vector2i(r, c))
	cells.shuffle()
	var removed : int = 0
	for cell : Vector2i in cells:
		if removed >= count:
			break
		var backup : int = g[cell.x][cell.y]
		g[cell.x][cell.y] = 0
		if _count_solutions(_copy_grid(g), 0) == 1:
			removed += 1
		else:
			g[cell.x][cell.y] = backup


func _count_solutions(g: Array[Array], count: int) -> int:
	if count > 1:
		return count
	for r : int in range(GRID_SIZE):
		for c : int in range(GRID_SIZE):
			if g[r][c] != 0:
				continue
			for n : int in range(1, 7):
				if _is_valid(g, r, c, n):
					g[r][c] = n
					count = _count_solutions(g, count)
					g[r][c] = 0
					if count > 1:
						return count
			return count
	return count + 1


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_N:
			_new_game()
			return
		if event.keycode == KEY_ESCAPE:
			get_tree().change_scene_to_file("res://scenes/careers/Architect/architect_intro.tscn")
			return

	if won:
		return

	if event is InputEventMouseButton and event.pressed:
		var mx : float = event.position.x - grid_x
		var my : float = event.position.y - grid_y
		if mx >= 0 and my >= 0 and mx < grid_w and my < grid_h:
			sel_col = int(mx / cell_size)
			sel_row = int(my / cell_size)
			queue_redraw()

	if event is InputEventKey and event.pressed and not event.echo:
		if sel_row < 0 or sel_col < 0 or given[sel_row][sel_col]:
			return
		var n : int = -1
		if event.keycode >= KEY_1 and event.keycode <= KEY_6:
			n = event.keycode - KEY_0
		elif event.keycode >= KEY_KP_1 and event.keycode <= KEY_KP_6:
			n = event.keycode - KEY_KP_0
		if n >= 1 and n <= 6:
			player[sel_row][sel_col] = n
			_check_win()
		elif event.keycode in [KEY_BACKSPACE, KEY_DELETE, KEY_0, KEY_KP_0]:
			player[sel_row][sel_col] = 0
		queue_redraw()


func _check_win() -> void:
	for r : int in range(GRID_SIZE):
		for c : int in range(GRID_SIZE):
			if (puzzle[r][c] if given[r][c] else player[r][c]) != solution[r][c]:
				return
	won               = true
	hud_label.visible = false
	win_panel.visible = true


func _draw() -> void:
	for i : int in range(dust_count):
		draw_circle(
			Vector2(randf() * grid_x * 2 + grid_w, randf() * grid_y * 2 + grid_h),
			randf() * 2.0 + 0.4,
			Color(c_dust.r, c_dust.g, c_dust.b, randf() * c_dust.a)
		)

	for r : int in range(GRID_SIZE):
		for c : int in range(GRID_SIZE):
			var rx   : float = grid_x + c * cell_size
			var ry   : float = grid_y + r * cell_size
			var rect : Rect2 = Rect2(rx, ry, cell_size, cell_size)
			var alt  : bool  = ((r / BOX_ROWS) + (c / BOX_COLS)) % 2 == 0
			draw_rect(rect, c_cell_alt if alt else c_cell)

			if sel_row >= 0 and sel_col >= 0:
				var same_box : bool = (r / BOX_ROWS == sel_row / BOX_ROWS) and (c / BOX_COLS == sel_col / BOX_COLS)
				if r == sel_row or c == sel_col or same_box:
					draw_rect(rect, c_highlight)
			if r == sel_row and c == sel_col:
				draw_rect(rect, c_selected)

			var val : int = puzzle[r][c] if given[r][c] else player[r][c]
			if val != 0 and val != solution[r][c]:
				draw_rect(rect, c_error)

	for i : int in range(GRID_SIZE + 1):
		var h_thick : bool = i % BOX_ROWS == 0
		var v_thick : bool = i % BOX_COLS == 0
		draw_line(Vector2(grid_x,                 grid_y + i * cell_size), Vector2(grid_x + grid_w, grid_y + i * cell_size),
			c_grid_thick if h_thick else c_grid_thin, line_thick_width if h_thick else line_thin_width)
		draw_line(Vector2(grid_x + i * cell_size, grid_y),                 Vector2(grid_x + i * cell_size, grid_y + grid_h),
			c_grid_thick if v_thick else c_grid_thin, line_thick_width if v_thick else line_thin_width)

	for r : int in range(GRID_SIZE):
		for c : int in range(GRID_SIZE):
			var num : int = puzzle[r][c] if given[r][c] else player[r][c]
			if num == 0:
				continue
			var fs  : int   = int(cell_size * (font_size_given if given[r][c] else font_size_player))
			var col : Color = c_num_given if given[r][c] else c_num_player
			if not given[r][c] and num != solution[r][c]:
				col = c_num_error
			var txt : String  = str(num)
			var tsz : Vector2 = font.get_string_size(txt, HORIZONTAL_ALIGNMENT_LEFT, -1, fs)
			var pos : Vector2 = Vector2(
				grid_x + c * cell_size + (cell_size - tsz.x) / 2.0,
				grid_y + r * cell_size + (cell_size + tsz.y) / 2.0 - tsz.y * 0.12
			)
			draw_string(font, pos + Vector2(1, 1), txt, HORIZONTAL_ALIGNMENT_LEFT, -1, fs, Color(col.r, col.g, col.b, chalk_smear_alpha))
			draw_string(font, pos, txt, HORIZONTAL_ALIGNMENT_LEFT, -1, fs, col)
