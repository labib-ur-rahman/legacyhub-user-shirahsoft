# Animated Splash Screen

## Overview
An elegant 6-stage animated splash screen that transitions smoothly through various visual elements before navigating to the home screen.

## Architecture
**Pattern**: Stateful Widget with Multiple AnimationControllers
**Location**: `lib/features/splash/views/screens/splash_screen.dart`

## Animation Stages

### Stage 1: Blank Page (500ms)
- Pure background color (#EEEFFC)
- Initial delay before animations start

### Stage 2: First Circle (600ms)
- Small circular gradient (175x175)
- Scale animation with elastic bounce
- Fade-in effect
- Radial gradient: #B8C7FF → #D4DCFF

### Stage 3: Second Circle (600ms)
- Large circular gradient (371x371)
- Scale animation with elastic bounce
- Fade-in effect
- Radial gradient: #D4DCFF → #EEEFFC

### Stage 4: App Logo (800ms)
- Center-positioned logo (175x167.473)
- Elastic scale animation
- Fade-in effect
- Uses `ImagePath.appLogo`

### Stage 5: Dot Line Pattern (600ms)
- Vertical dotted line (246x622.5)
- Fade-in animation
- Uses `ImagePath.dotLine`

### Stage 6: Circular Dots (800ms)
- 6 circular dots at strategic positions
- Staggered appearance (100ms delay between each)
- Scale and fade animations
- Uses `SvgPath.circularDot` with `SvgIconHelper`

## Animation Details

### Controllers
```dart
_circle1Controller      // First circle
_circle2Controller      // Second circle
_logoController         // App logo
_dotLineController      // Dot line pattern
_circularDotsController // Circular dots
```

### Timing Sequence
```
0ms     → Blank page starts
500ms   → First circle appears (600ms animation)
1400ms  → Second circle appears (600ms animation)
2300ms  → Logo appears (800ms animation)
3500ms  → Dot line appears (600ms animation)
4100ms  → Circular dots appear (800ms animation)
5900ms  → Navigate to home screen
```

### Total Duration
**~5.9 seconds** from screen load to navigation

## Key Features

1. **Smooth Transitions**: Uses `CurvedAnimation` with various curves:
   - `Curves.easeOutBack` - Circles and dots (bouncy effect)
   - `Curves.elasticOut` - Logo (elastic bounce)
   - `Curves.easeIn` - Opacity transitions

2. **Responsive Design**: All sizes use ScreenUtil extensions (.w, .h)

3. **Staggered Dots**: Each circular dot appears with a 0.1-second delay

4. **Layer Order**: Elements are stacked correctly with proper z-index

5. **Memory Management**: All controllers disposed properly

## Assets Required

### Images
- `assets/images/logo.png` - App logo
- `assets/images/dot-line.png` - Dotted line pattern

### SVG
- `assets/svg/circular-dot.svg` - Circular dot icon

## Circular Dot Positions
Based on Figma design, dots appear at:
1. Top-left area (24, 89) - Calling position
2. Top-right area (233, 174) - Buy position
3. Left-middle area (54, 257) - Home position
4. Left-bottom area (55, 585) - Heart position
5. Bottom-center area (110, 724) - Location position
6. Right-bottom area (227, 622) - Calendar position

## Navigation
After all animations complete, navigates to:
```dart
Get.offAllNamed(AppRoutes.getHomeScreen());
```

## Customization

### Adjust Animation Speed
```dart
// In _initializeAnimations()
_circle1Controller = AnimationController(
  vsync: this,
  duration: const Duration(milliseconds: 600), // Change this
);
```

### Adjust Timing Between Stages
```dart
// In _startAnimationSequence()
await Future.delayed(const Duration(milliseconds: 300)); // Change this
```

### Modify Colors
```dart
// Circle 1 gradient
colors: [
  const Color(0xFFB8C7FF).withValues(alpha: 0.8),
  const Color(0xFFD4DCFF).withValues(alpha: 0.3),
]

// Circle 2 gradient
colors: [
  const Color(0xFFD4DCFF).withValues(alpha: 0.6),
  const Color(0xFFEEEFFC).withValues(alpha: 0.1),
]
```

## Best Practices Followed

✅ **Package Imports**: All imports use package format
✅ **Responsive Sizing**: ScreenUtil extensions everywhere
✅ **Proper Disposal**: All controllers disposed
✅ **Animation Efficiency**: Uses `AnimatedBuilder` with `Listenable.merge`
✅ **State Safety**: Checks `mounted` before navigation
✅ **Asset Constants**: Uses `ImagePath` and `SvgPath` classes
✅ **Helper Usage**: Uses `SvgIconHelper` for SVG rendering

## Testing

1. Ensure all assets exist in correct paths
2. Test navigation to home screen
3. Verify animations on different screen sizes
4. Check performance on low-end devices
5. Test hot reload behavior

## Performance Considerations

- Uses single `AnimatedBuilder` for multiple animations
- Merges all animation listeners efficiently
- Proper controller disposal prevents memory leaks
- Images loaded once, no repeated builds
- Smooth 60fps animations on most devices
