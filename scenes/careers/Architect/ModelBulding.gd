extends Node2D

const COLS   = 10
const ROWS   = 20
const BORDER = 2

# Vertical margin as a fraction of screen height (0.05 = 5 %)
const MARGIN_V = 0.05

const PIECES = [
	[[0,0],[0,1],[0,2],[0,3]],  # I
	[[0,0],[0,1],[1,0],[1,1]],  # O
	[[0,1],[1,0],[1,1],[1,2]],  # T
	[[0,1],[0,2],[1,0],[1,1]],  # S
	[[0,0],[0,1],[1,1],[1,2]],  # Z
	[[0,0],[1,0],[1,1],[1,2]],  # J
	[[0,2],[1,0],[1,1],[1,2]],  # L
]

# ── Runtime layout ────────────────────────────────────────────────────────────
var SW : float
var SH : float
var CELL : float
var BW : float
var BH : float
var BX : float
var BY : float

var left_x  : float
var left_w  : float
var right_x : float
var right_w : float

# Preview box shared geometry (NEXT and HOLD are identical size)
var preview_w : float
var preview_h : float

var next_box_x : float
var next_box_y : float
var hold_box_x : float
var hold_box_y : float

# ── Node refs ─────────────────────────────────────────────────────────────────
@onready var overlay_lbl : Label = $UI/OverlayLabel
@onready var score_lbl   : Label = $UI/ScoreLabel
@onready var score_val   : Label = $UI/ScoreValue
@onready var level_lbl   : Label = $UI/LevelLabel
@onready var level_val   : Label = $UI/LevelValue
@onready var lines_lbl   : Label = $UI/LinesLabel
@onready var lines_val   : Label = $UI/LinesValue
@onready var next_lbl    : Label = $UI/NextLabel
@onready var hold_lbl    : Label = $UI/HoldLabel
@onready var info_lbl    : Label = $UI/InfoLabel

# ── Game state ────────────────────────────────────────────────────────────────
var board         = []
var cur_piece     = []
var cur_type      : int  = 0
var next_type     : int  = 0
var hold_type     : int  = -1   # -1 = empty
var hold_used     : bool = false   # can only hold once per piece
var score         : int  = 0
var level         : int  = 1
var lines_cleared : int  = 0
var game_over     : bool = false
var paused        : bool = false

# Gravity
var fall_timer    : float = 0.0
var fall_interval : float = 0.8

# Soft-drop DAS (Delayed Auto-Shift)
const SOFT_INITIAL  = 0.15   # seconds before repeat begins
const SOFT_REPEAT   = 0.05   # repeat interval
var soft_held       : bool  = false
var soft_timer      : float = 0.0
var soft_repeat_active : bool = false

# ─────────────────────────────────────────────────────────────────────────────
func _ready():
	var vp = get_viewport().get_visible_rect().size
	SW = vp.x
	SH = vp.y

	# Board fills screen vertically with MARGIN_V top+bottom
	var usable_h = SH * (1.0 - MARGIN_V * 2.0)
	CELL = floor(usable_h / ROWS)
	CELL = max(CELL, 16.0)
	BH   = ROWS * CELL
	BW   = COLS * CELL
	BX   = floor((SW - BW) / 2.0)
	BY   = floor((SH - BH) / 2.0)

	left_x  = 0.0
	left_w  = BX
	right_x = BX + BW
	right_w = SW - right_x

	# Preview boxes: both same size, placed symmetrically
	preview_w = min(right_w * 0.60, CELL * 5.0)
	preview_h = CELL * 3.5

	# NEXT – in right panel, vertically centred near top
	next_box_x = right_x + (right_w - preview_w) / 2.0
	next_box_y = BY

	# HOLD – mirror of NEXT in left panel
	hold_box_x = left_x + (left_w - preview_w) / 2.0
	hold_box_y = BY

	_position_labels()
	_init_board()
	next_type = randi() % PIECES.size()
	_spawn_piece()
	_update_labels()

# ─────────────────────────────────────────────────────────────────────────────
func _process(delta):
	if game_over or paused:
		return

	# Gravity
	fall_timer += delta
	if fall_timer >= fall_interval:
		fall_timer = 0.0
		_move_down()

	# Soft-drop DAS
	if soft_held:
		soft_timer += delta
		if not soft_repeat_active:
			if soft_timer >= SOFT_INITIAL:
				soft_repeat_active = true
				soft_timer = 0.0
		else:
			if soft_timer >= SOFT_REPEAT:
				soft_timer = 0.0
				_move_down()

func _input(event):
	if not event is InputEventKey:
		return
	var key := event as InputEventKey

	# ── Space = hard drop ONLY (intercept before anything else) ──
	if key.keycode == KEY_SPACE and key.pressed and not key.echo:
		if not game_over and not paused:
			_hard_drop()
		return

	# ── Enter = pause / restart ONLY ──
	if key.keycode == KEY_ENTER and key.pressed and not key.echo:
		if game_over:
			_restart()
		else:
			paused = !paused
			_update_labels()
			queue_redraw()
		return

	if game_over or paused:
		return

	# ── Hold = C or Left Shift ──
	if key.pressed and not key.echo:
		if key.keycode == KEY_C or key.keycode == KEY_SHIFT:
			_do_hold()
			return

	# ── Movement (pressed, no echo) ──
	if key.pressed and not key.echo:
		if key.keycode == KEY_LEFT:
			_try_move(0, -1)
		elif key.keycode == KEY_RIGHT:
			_try_move(0, 1)
		elif key.keycode == KEY_UP:
			_rotate()

	# ── Soft drop DAS ──
	if key.keycode == KEY_DOWN:
		if key.pressed and not key.echo:
			soft_held = true
			soft_timer = 0.0
			soft_repeat_active = false
			_move_down()
		elif not key.pressed:
			soft_held = false
			soft_repeat_active = false

# ─────────────────────────────────────────────────────────────────────────────
func _draw():
	if SW == 0:
		return

	draw_rect(Rect2(0, 0, SW, SH), Color.DARK_BLUE , true)

	# Board
	_outlined_rect(
		Rect2(BX - BORDER, BY - BORDER, BW + BORDER*2, BH + BORDER*2),
		Color.DARK_BLUE , Color.WHITE, BORDER)

	for r in range(ROWS):
		for c in range(COLS):
			var rect = Rect2(BX + c*CELL, BY + r*CELL, CELL, CELL)
			if board[r][c]:
				_tetro_cell(rect)
			else:
				draw_rect(rect, Color.DARK_BLUE , true)

	# Ghost
	for pos in _get_ghost():
		var rect = Rect2(BX + pos[1]*CELL + 2, BY + pos[0]*CELL + 2, CELL - 4, CELL - 4)
		draw_rect(rect, Color(1, 1, 1, 0.20), false)

	# Active piece
	for pos in cur_piece:
		_tetro_cell(Rect2(BX + pos[1]*CELL, BY + pos[0]*CELL, CELL, CELL))

	# Left panel: stat boxes + HOLD box
	_draw_stat_boxes()
	_draw_preview_box(hold_box_x, hold_box_y, hold_type, hold_used)

	# Right panel: NEXT box
	_draw_preview_box(next_box_x, next_box_y, next_type, false)

	# Overlay
	if paused:
		_draw_overlay("PAUSED", "Enter to Resume")
	elif game_over:
		_draw_overlay("GAME OVER", "Score: %d\n\nEnter to Restart" % score)
	else:
		if overlay_lbl:
			overlay_lbl.visible = false

# ── Draw helpers ──────────────────────────────────────────────────────────────
func _tetro_cell(rect: Rect2):
	draw_rect(rect, Color.DARK_BLUE , true)
	var t = max(2.0, CELL * 0.07)
	draw_rect(Rect2(rect.position.x, rect.position.y, rect.size.x, t), Color.WHITE, true)
	draw_rect(Rect2(rect.position.x, rect.position.y + rect.size.y - t, rect.size.x, t), Color.WHITE, true)
	draw_rect(Rect2(rect.position.x, rect.position.y, t, rect.size.y), Color.WHITE, true)
	draw_rect(Rect2(rect.position.x + rect.size.x - t, rect.position.y, t, rect.size.y), Color.WHITE, true)

func _outlined_rect(rect: Rect2, fill: Color, outline: Color, thickness: int):
	draw_rect(rect, fill, true)
	for i in range(thickness):
		draw_rect(Rect2(rect.position.x+i, rect.position.y+i,
						rect.size.x - i*2, rect.size.y - i*2), outline, false)

func _draw_stat_boxes():
	var bw  = min(left_w * 0.72, CELL * 7)
	var bh  = CELL * 2.2
	var gap = CELL * 0.6
	# Start stat boxes below the hold box
	var bx  = left_x + (left_w - bw) / 2.0
	var by_ = hold_box_y + preview_h + CELL * 1.5
	for _i in range(3):
		_outlined_rect(Rect2(bx, by_, bw, bh), Color.DARK_BLUE , Color.WHITE, BORDER)
		by_ += bh + gap

func _draw_preview_box(bx: float, by: float, piece_type: int, dimmed: bool):
	_outlined_rect(
		Rect2(bx - BORDER, by - BORDER, preview_w + BORDER*2, preview_h + BORDER*2),
		Color.DARK_BLUE , Color.WHITE, BORDER)

	if piece_type < 0:
		return   # empty hold slot

	var offsets = PIECES[piece_type]
	var min_c = offsets[0][1]; var max_c = offsets[0][1]
	var min_r = offsets[0][0]; var max_r = offsets[0][0]
	for o in offsets:
		min_c = min(min_c, o[1]); max_c = max(max_c, o[1])
		min_r = min(min_r, o[0]); max_r = max(max_r, o[0])

	var pc   = min(CELL, preview_w / 5.0)
	var pw   = (max_c - min_c + 1) * pc
	var ph_  = (max_r - min_r + 1) * pc
	var lres = preview_h * 0.30
	var area = preview_h - lres
	var ox   = bx + (preview_w - pw) / 2.0
	var oy   = by + lres + (area - ph_) / 2.0

	var alpha = 0.35 if dimmed else 1.0
	for o in offsets:
		var rect = Rect2(ox + (o[1]-min_c)*pc, oy + (o[0]-min_r)*pc, pc, pc)
		if dimmed:
			# Draw dimmed outline only
			var t = max(2.0, pc * 0.07)
			draw_rect(rect, Color.DARK_BLUE , true)
			draw_rect(Rect2(rect.position.x, rect.position.y, rect.size.x, t), Color(1,1,1,alpha), true)
			draw_rect(Rect2(rect.position.x, rect.position.y + rect.size.y - t, rect.size.x, t), Color(1,1,1,alpha), true)
			draw_rect(Rect2(rect.position.x, rect.position.y, t, rect.size.y), Color(1,1,1,alpha), true)
			draw_rect(Rect2(rect.position.x + rect.size.x - t, rect.position.y, t, rect.size.y), Color(1,1,1,alpha), true)
		else:
			_tetro_cell(rect)

func _draw_overlay(title: String, subtitle: String):
	draw_rect(Rect2(BX, BY, BW, BH), Color(0, 0, 0, 0.82), true)
	var bw = BW * 0.85
	var bh = CELL * 6.0
	var bx = BX + (BW - bw) / 2.0
	var by = BY + (BH - bh) / 2.0
	_outlined_rect(Rect2(bx, by, bw, bh), Color.DARK_BLUE , Color.WHITE, 3)
	if overlay_lbl:
		overlay_lbl.text     = title + "\n\n" + subtitle
		overlay_lbl.position = Vector2(bx, by)
		overlay_lbl.size     = Vector2(bw, bh)
		overlay_lbl.visible  = true

# ── Label positioning ─────────────────────────────────────────────────────────
func _position_labels():
	# HOLD label – inside the hold box header area
	if hold_lbl:
		hold_lbl.position = Vector2(hold_box_x, hold_box_y + preview_h * 0.03)
		hold_lbl.size     = Vector2(preview_w, preview_h * 0.28)

	# NEXT label – inside the next box header area
	if next_lbl:
		next_lbl.position = Vector2(next_box_x, next_box_y + preview_h * 0.03)
		next_lbl.size     = Vector2(preview_w, preview_h * 0.28)

	# Stat boxes – stacked below the hold box
	var bw_s  = min(left_w * 0.72, CELL * 7)
	var bh_s  = CELL * 2.2
	var gap_s = CELL * 0.6
	var bx_s  = left_x + (left_w - bw_s) / 2.0
	var by_s  = hold_box_y + preview_h + CELL * 1.5

	var blocks = [
		[score_lbl, score_val],
		[level_lbl, level_val],
		[lines_lbl, lines_val],
	]
	for i in range(3):
		var lbl : Label = blocks[i][0]
		var val : Label = blocks[i][1]
		var box_y = by_s + i * (bh_s + gap_s)
		if lbl:
			lbl.position = Vector2(bx_s, box_y + bh_s * 0.05)
			lbl.size     = Vector2(bw_s, bh_s * 0.38)
		if val:
			val.position = Vector2(bx_s, box_y + bh_s * 0.42)
			val.size     = Vector2(bw_s, bh_s * 0.55)

	# INFO block – bottom-right corner of right panel
	if info_lbl:
		var iw = right_w * 0.85
		var ih = SH * 0.40
		var ix = right_x + (right_w - iw) / 2.0
		var iy = SH - ih - CELL * 0.6
		info_lbl.position = Vector2(ix, iy)
		info_lbl.size     = Vector2(iw, ih)

	if overlay_lbl:
		overlay_lbl.visible = false

# ── Game Logic ────────────────────────────────────────────────────────────────
func _init_board():
	board = []
	for r in range(ROWS):
		board.append([])
		for _c in range(COLS):
			board[r].append(null)

func _spawn_piece():
	cur_type  = next_type
	next_type = randi() % PIECES.size()
	hold_used = false
	_place_at_top(cur_type)
	queue_redraw()

func _do_hold():
	if hold_used:
		return   # one hold per piece
	hold_used = true
	if hold_type < 0:
		# First hold: stash current, pull from next queue
		hold_type = cur_type
		cur_type  = next_type
		next_type = randi() % PIECES.size()
	else:
		# Swap current <-> held
		var tmp   = hold_type
		hold_type = cur_type
		cur_type  = tmp
	_place_at_top(cur_type)
	queue_redraw()

# Place piece_type at spawn position, set game_over if blocked
func _place_at_top(piece_type: int):
	cur_piece = []
	var start_col = COLS / 2 - 2
	for o in PIECES[piece_type]:
		cur_piece.append([o[0], o[1] + start_col])
	if not _valid(cur_piece):
		game_over = true

func _valid(piece) -> bool:
	for pos in piece:
		if pos[0] < 0 or pos[0] >= ROWS or pos[1] < 0 or pos[1] >= COLS:
			return false
		if board[pos[0]][pos[1]] != null:
			return false
	return true

func _try_move(dr: int, dc: int) -> bool:
	var moved = []
	for pos in cur_piece:
		moved.append([pos[0]+dr, pos[1]+dc])
	if _valid(moved):
		cur_piece = moved
		queue_redraw()
		return true
	return false

func _move_down():
	if not _try_move(1, 0):
		_lock_piece()

func _hard_drop():
	while _try_move(1, 0):
		pass
	_lock_piece()

func _rotate():
	var min_r = cur_piece[0][0]; var max_r = cur_piece[0][0]
	var min_c = cur_piece[0][1]; var max_c = cur_piece[0][1]
	for pos in cur_piece:
		min_r = min(min_r, pos[0]); max_r = max(max_r, pos[0])
		min_c = min(min_c, pos[1]); max_c = max(max_c, pos[1])
	var pr = (min_r + max_r) / 2.0
	var pc = (min_c + max_c) / 2.0
	var rotated = []
	for pos in cur_piece:
		rotated.append([int(round(pr + pos[1] - pc)), int(round(pc - (pos[0] - pr)))])
	for shift in [0, 1, -1, 2, -2]:
		var kicked = []
		for p in rotated:
			kicked.append([p[0], p[1]+shift])
		if _valid(kicked):
			cur_piece = kicked
			queue_redraw()
			return

func _get_ghost() -> Array:
	var ghost = cur_piece.duplicate(true)
	while true:
		var down = []
		for pos in ghost:
			down.append([pos[0]+1, pos[1]])
		if _valid(down):
			ghost = down
		else:
			break
	return ghost

func _lock_piece():
	for pos in cur_piece:
		board[pos[0]][pos[1]] = true
	_clear_lines()
	_spawn_piece()
	_update_labels()
	queue_redraw()

func _clear_lines():
	var cleared = 0
	var new_board = []
	for r in range(ROWS):
		var full = true
		for c in range(COLS):
			if not board[r][c]:
				full = false; break
		if not full:
			new_board.append(board[r])
		else:
			cleared += 1
	while new_board.size() < ROWS:
		var row = []
		for _c in range(COLS): row.append(null)
		new_board.insert(0, row)
	board = new_board
	if cleared > 0:
		var pts = [0, 100, 300, 500, 800]
		score         += pts[min(cleared, 4)] * level
		lines_cleared += cleared
		level          = lines_cleared / 10 + 1
		fall_interval  = max(0.1, 0.8 - (level - 1) * 0.07)

func _update_labels():
	if overlay_lbl: overlay_lbl.visible = false
	if score_val:   score_val.text = str(score)
	if level_val:   level_val.text = str(level)
	if lines_val:   lines_val.text = str(lines_cleared)
	queue_redraw()

func _restart():
	score = 0; level = 1; lines_cleared = 0
	hold_type = -1; hold_used = false
	game_over = false; paused = false
	soft_held = false; soft_repeat_active = false
	fall_interval = 0.8; fall_timer = 0.0
	_init_board()
	next_type = randi() % PIECES.size()
	_spawn_piece()
	_update_labels()