// Get a reference to the canvas and other elements
const canvas = document.getElementById('drawingCanvas');
const ctx = canvas.getContext('2d');
const colorPicker = document.getElementById('colorPicker');
const eraserButton = document.getElementById('eraserButton');
const brushSizeSlider = document.getElementById('brushSize');
const clearButton = document.getElementById('clearButton');
let drawing = false;
let eraserActive = false;

// Set canvas dimensions
function resizeCanvas() {
    canvas.width = window.innerWidth;
    canvas.height = window.innerHeight;
}

// Resize the canvas to fill browser window dynamically
window.addEventListener('resize', resizeCanvas);
resizeCanvas(); // Initialize canvas size

// Start drawing
function startDrawing(e) {
    drawing = true;
    draw(e);
}

// Stop drawing
function stopDrawing() {
    drawing = false;
    ctx.beginPath();
}

// Draw on the canvas
function draw(e) {
    if (!drawing) return;

    const rect = canvas.getBoundingClientRect();
    const x = e.clientX - rect.left;
    const y = e.clientY - rect.top;

    ctx.lineWidth = brushSizeSlider.value; // Brush size from slider
    ctx.lineCap = 'round'; // Brush shape
    ctx.strokeStyle = eraserActive ? 'white' : colorPicker.value; // Use white for eraser, otherwise selected color

    ctx.lineTo(x, y);
    ctx.stroke();
    ctx.beginPath();
    ctx.moveTo(x, y);
}

// Toggle eraser
function toggleEraser() {
    eraserActive = !eraserActive;
    eraserButton.textContent = eraserActive ? 'Pen' : 'Eraser'; // Change button text
}

// Clear Canvas Function
function clearCanvas() {
    ctx.clearRect(0, 0, canvas.width, canvas.height);
}

// Event listeners
canvas.addEventListener('mousedown', startDrawing);
canvas.addEventListener('mouseup', stopDrawing);
canvas.addEventListener('mousemove', draw);
eraserButton.addEventListener('click', toggleEraser);
clearButton.addEventListener('click', clearCanvas);
