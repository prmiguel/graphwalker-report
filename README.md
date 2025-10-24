# GraphWalker Report

An interactive web-based visualization tool for GraphWalker test execution sequences. This single-page application allows you to visualize and navigate through graph-based test models with animated transitions, curved edges, self-loops, and automated playback capabilities.

## Features

### 🎯 Core Functionality
- **Interactive Graph Visualization** - Display vertices (nodes) and edges with dynamic positioning
- **Step-by-Step Navigation** - Walk through test sequences using Previous/Next buttons
- **Automated Playback** - Play through entire sequence automatically with Play/Pause controls
- **Variable Speed Control** - Adjust playback speed from 0.4x to 3.0x with real-time slider
- **Alternating Display** - Shows vertices and edges alternately in the execution path
- **Status Tracking** - Real-time display of current step, element type, and progress

### 🎨 Advanced Visualization
- **Curved Edges** - Prevents overlapping when multiple edges connect the same nodes
- **Self-Loop Support** - Circular arrows for edges connecting a vertex to itself
- **Smart Edge Routing** - Bidirectional edges automatically curve in opposite directions
- **Active Highlighting** - Current vertex/edge highlighted in purple with glow effect
- **Path Tracking** - Visited vertices shown in green
- **Edge Labels** - Clear display of edge names with contrasting background

### 🔍 Visualization Controls
- **Zoom In/Out** - Scale the graph to see details or overview
- **Fit to Screen** - Automatically adjust zoom to fit entire graph
- **Reset View** - Return to default zoom and position
- **Pan & Drag** - Click and drag to move the graph around
- **Mouse Wheel Zoom** - Scroll to zoom in/out centered on cursor

### 🎬 Playback Features
- **Play All** - Automatically navigate through entire sequence
- **Pause** - Stop playback at any point
- **Speed Control** - Adjustable playback speed (100ms to 3000ms between steps)
- **Restart Capability** - Change speed during playback to restart with new timing
- **Auto-Stop** - Playback automatically stops at sequence end

### 🎨 Visual Feedback
- **Smooth Animations** - Transitions between steps with animation
- **Image Display** - Shows associated images for vertices
- **Responsive Design** - Adapts to different screen sizes
- **Modern UI** - Clean, professional interface with gradient background

## Installation

No installation required! This is a standalone HTML file.

### Option 1: Direct Use
1. Download `index.html`
2. Open in any modern web browser
3. Start using immediately

### Option 2: Local Server (Optional)
```bash
# Using Python 3
python -m http.server 8000

# Using Node.js
npx http-server

# Then navigate to http://localhost:8000
```

## Usage

### Basic Navigation

1. **Start Walk** - Click to load the sequence and begin at the first step
2. **Play All** - Automatically play through the entire sequence
3. **Pause** - Stop automatic playback at current position
4. **Next** - Move forward to the next element (vertex or edge)
5. **Previous** - Move backward to the previous element
6. **Speed Control** - Adjust slider to change playback speed (0.4x to 3.0x)
7. **Zoom Controls** - Use toolbar buttons to adjust view

### Playback Controls

- **Adjusting Speed**: Move the slider left (slower) or right (faster)
  - Minimum: 0.4x (3000ms between steps)
  - Default: 1.0x (1000ms between steps)
  - Maximum: 3.0x (100ms between steps)
- **During Playback**: Speed changes automatically restart playback with new timing
- **Manual Control**: Previous/Next buttons are disabled during automatic playback

### Keyboard Shortcuts

Currently mouse-based. Future versions may include keyboard navigation.

### Graph Interaction

- **Pan**: Click and drag anywhere on the canvas
- **Zoom**: Use mouse wheel or zoom buttons
- **Fit**: Click "Fit to Screen" to auto-adjust view

## Data Format

The application uses the GraphWalker JSON schema format:

```json
{
  "name": "Model Name",
  "selectedModelIndex": 0,
  "selectedElementId": "uuid",
  "models": [
    {
      "id": "model-id",
      "name": "Model Name",
      "generator": "random(edge_coverage(100))",
      "startElementId": "vertex-id",
      "vertices": [
        {
          "id": "vertex-id",
          "name": "Vertex Name",
          "properties": {
            "x": 150,
            "y": 150
          }
        }
      ],
      "edges": [
        {
          "id": "edge-id",
          "name": "e_EdgeName",
          "sourceVertexId": "source-vertex-id",
          "targetVertexId": "target-vertex-id",
          "actions": ["action1"],
          "guard": ""
        }
      ]
    }
  ],
  "sequence": [
    {
      "type": "vertex",
      "id": "vertex-id",
      "image": "data:image/svg+xml;base64,..."
    },
    {
      "type": "edge",
      "id": "edge-id"
    }
  ]
}
```

### Sequence Format

The `sequence` array alternates between vertices and edges:

- **Vertex Entry**:
  ```json
  {
    "type": "vertex",
    "id": "vertex-id",
    "image": "base64-encoded-image (optional)"
  }
  ```

- **Edge Entry**:
  ```json
  {
    "type": "edge",
    "id": "edge-id"
  }
  ```

### Customization

### Modifying Graph Data

Edit the `graphData` object in the `<script>` section:

```javascript
const graphData = {
  name: "Your Model Name",
  models: [
    {
      vertices: [...],
      edges: [
        // Self-loops are supported!
        { 
          id: "edge-a-a", 
          name: "e_SelfLoop",
          sourceVertexId: "vertex-a",
          targetVertexId: "vertex-a"
        }
      ]
    }
  ],
  sequence: [...]
};
```

### Curved Edges

The application automatically handles:
- **Bidirectional edges** - Curves in opposite directions
- **Self-loops** - Displayed as circles above the vertex
- **Multiple edges** - Progressive curve offset for clarity

### Playback Speed

Adjust the default playback speed by modifying:

```javascript
let playbackSpeed = 1000; // milliseconds (default: 1 second)
```

### Styling

Modify the CSS variables in the `<style>` section:

```css
/* Active node color */
.fillStyle = '#667eea';

/* Visited node color */
.fillStyle = '#51cf66';

/* Background gradient */
background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
```

### Adding Images

Images can be added as base64-encoded data URLs:

```javascript
{
  type: "vertex",
  id: "vertex-a",
  image: "data:image/svg+xml;base64,PHN2ZyB3aWR0aD0i..."
}
```

## Browser Compatibility

- ✅ Chrome/Edge 90+
- ✅ Firefox 88+
- ✅ Safari 14+
- ✅ Opera 76+

### Required Features
- HTML5 Canvas
- ES6 JavaScript
- CSS3 Transforms

## Performance

### Optimization Tips

1. **Large Graphs**: Use "Fit to Screen" for initial view
2. **Many Nodes**: Keep vertex names short for better rendering
3. **Long Sequences**: Consider breaking into smaller test suites
4. **Images**: Use compressed/optimized images in base64

### Recommended Limits
- Vertices: Up to 100 nodes
- Edges: Up to 200 connections
- Sequence Length: Up to 500 steps

## Troubleshooting

### Graph Not Displaying
- Ensure `graphData` is properly formatted JSON
- Check browser console for errors
- Verify all vertex IDs referenced in edges exist

### Navigation Buttons Disabled
- Click "Start Walk" to initialize the sequence
- Check if sequence array has valid data

### Images Not Showing
- Verify base64 encoding is correct
- Ensure data URL includes proper MIME type
- Check that image data is valid

### Performance Issues
- Reduce number of vertices/edges
- Simplify edge names
- Use smaller/compressed images
- Decrease playback speed for smoother animations

### Playback Not Working
- Ensure sequence is loaded (click "Start Walk" first)
- Check browser console for JavaScript errors
- Verify playbackSpeed variable is properly initialized

### Curved Edges Overlapping
- Increase curve offset in `drawCurvedArrow` function
- Adjust `curveOffset` calculation: `20 + (edgeIndex * 15)`
- For very dense graphs, consider repositioning vertices

## Technical Details

### Architecture
- **Single Page Application** - Pure HTML/CSS/JavaScript
- **No Dependencies** - No external libraries required
- **Canvas Rendering** - HTML5 Canvas for graph visualization
- **Client-Side Only** - All processing happens in browser

### Canvas Drawing
- **Coordinate System**: Custom with zoom/pan transformations
- **Rendering**: Optimized with requestAnimationFrame
- **Scaling**: Responsive to window resize
- **Edge Types**: Straight lines, curved paths, and self-loops
- **Collision Detection**: Smart curve offset calculation

### Playback System
- **Interval-based**: Uses setInterval for consistent timing
- **State Management**: Tracks playing/paused state
- **Auto-cleanup**: Clears intervals on stop/pause
- **Speed Adjustment**: Dynamic interval recalculation

## Development

### Project Structure
```
graphwalker-report/
├── index.html          # Complete application
└── README.md          # This file
```

### Code Organization
- **CSS**: Embedded in `<style>` tags
- **JavaScript**: Embedded in `<script>` tags
- **Data**: JSON object within JavaScript

### Adding Features

To extend functionality, modify the JavaScript section:

```javascript
// Add new function
function myNewFeature() {
  // Your code here
}

// Add to event handlers
document.getElementById('myButton').addEventListener('click', myNewFeature);
```

## Contributing

Contributions are welcome! To contribute:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

### Contribution Guidelines
- Maintain single-file architecture
- Follow existing code style
- Test in multiple browsers
- Update README if needed

## License

MIT License - Feel free to use and modify for your projects.

## Acknowledgments

- Built for [GraphWalker](https://graphwalker.github.io/) test framework
- Inspired by model-based testing visualization needs
- Uses HTML5 Canvas API for rendering

## Support

For issues, questions, or feature requests:
- Open an issue on GitHub
- Check existing documentation
- Review the troubleshooting section

## Roadmap

Future enhancements under consideration:
- [x] Curved edges for overlapping paths ✅
- [x] Self-loop edge support ✅
- [x] Auto-play sequence feature ✅
- [x] Playback speed control ✅
- [ ] Export graph as image
- [ ] Load external JSON files
- [ ] Keyboard navigation shortcuts
- [ ] Dark mode theme
- [ ] Edge weight visualization
- [ ] Graph layout algorithms
- [ ] Performance optimization for large graphs

---

**Made with ❤️ for the testing community**
