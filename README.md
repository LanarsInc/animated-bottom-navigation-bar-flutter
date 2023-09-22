[![SWUbanner](https://raw.githubusercontent.com/vshymanskyy/StandWithUkraine/main/banner2-direct.svg)](https://vshymanskyy.github.io/StandWithUkraine)

AnimatedBottomNavigationBar is a customizable widget inspired by [dribble shot](https://dribbble.com/shots/7134849-Simple-Tab-Bar-Animation).

[![pub package](https://img.shields.io/pub/v/animated_bottom_navigation_bar.svg)](https://pub.dev/packages/animated_bottom_navigation_bar)

[!["Buy Me A Coffee"](https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png)](https://www.buymeacoffee.com/lanars)

<img src="https://raw.githubusercontent.com/LanarsInc/animated-bottom-navigation-bar-flutter/master/doc/assets/animated-bottom-navigation-bar.gif" width="300">

With `AnimatedBottomNavigationBar.builder` you are able to customize tab view however you need. In this case you are responsible to handle an active(inactive) state of tabs.

<img src="https://raw.githubusercontent.com/LanarsInc/animated-bottom-navigation-bar-flutter/master/doc/assets/animated-bottom-navigation-bar.jpg" width="300">

# Getting Started

To get started, place your `AnimatedBottomNavigationBar` or `AnimatedBottomNavigationBar.builder` in the bottomNavigationBar slot of a `Scaffold`.
The `AnimatedBottomNavigationBar` respects `FloatingActionButton` location.
For example:

```dart
Scaffold(
   body: Container(), //destination screen
   floatingActionButton: FloatingActionButton(
      //params
   ),
   floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
   bottomNavigationBar: AnimatedBottomNavigationBar(
      icons: iconList,
      activeIndex: _bottomNavIndex,
      gapLocation: GapLocation.center,
      notchSmoothness: NotchSmoothness.verySmoothEdge,
      leftCornerRadius: 32,
      rightCornerRadius: 32,
      onTap: (index) => setState(() => _bottomNavIndex = index),
      //other params
   ),
);
```

There is also a more flexible way to build `bottomNavigationBar` with Builder (see [example](https://pub.dev/packages/animated_bottom_navigation_bar/example) for more insights): 
```dart
Scaffold(
   body: Container(), //destination screen
   floatingActionButton: FloatingActionButton(
      //params
   ),
   floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
   bottomNavigationBar: AnimatedBottomNavigationBar.builder(
      itemCount: iconList.length,
      tabBuilder: (int index, bool isActive) {
        return Icon(
          iconList[index],
          size: 24,
          color: isActive ? colors.activeNavigationBarColor : colors.notActiveNavigationBarColor,
        );
      activeIndex: _bottomNavIndex,
      gapLocation: GapLocation.center,
      notchSmoothness: NotchSmoothness.verySmoothEdge,
      leftCornerRadius: 32,
      rightCornerRadius: 32,
      onTap: (index) => setState(() => _bottomNavIndex = index),
      //other params
   ),
);
```


<img src="https://raw.githubusercontent.com/LanarsInc/animated-bottom-navigation-bar-flutter/master/doc/assets/example-cornered-notched-bar.jpeg" width="300">

# Customization

AnimatedBottomNavigationBar is customizable and works with 2, 3, 4, or 5 navigation elements.
```dart
Scaffold(
   bottomNavigationBar: AnimatedBottomNavigationBar(
      icons: iconList,
      activeIndex: _bottomNavIndex,
      onTap: (index) => setState(() => _bottomNavIndex = index),
      //other params
   ),
);
```
<img src="https://raw.githubusercontent.com/LanarsInc/animated-bottom-navigation-bar-flutter/master/doc/assets/example-plain-bar.jpeg" width="300">

```dart
Scaffold(
   bottomNavigationBar: AnimatedBottomNavigationBar(
      icons: iconList,
      activeIndex: _bottomNavIndex,
      leftCornerRadius: 32,
      rightCornerRadius: 32,
      onTap: (index) => setState(() => _bottomNavIndex = index),
      //other params
   ),
);
```
<img src="https://raw.githubusercontent.com/LanarsInc/animated-bottom-navigation-bar-flutter/master/doc/assets/example-cornered-bar.jpeg" width="300">

```dart
Scaffold(
   floatingActionButton: FloatingActionButton(
      //params
   ),
   floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
   bottomNavigationBar: AnimatedBottomNavigationBar(
      icons: iconList,
      activeIndex: _bottomNavIndex,
      gapLocation: GapLocation.end,
      notchSmoothness: NotchSmoothness.defaultEdge,
      onTap: (index) => setState(() => _bottomNavIndex = index),
      //other params
   ),
);
```
<img src="https://raw.githubusercontent.com/LanarsInc/animated-bottom-navigation-bar-flutter/master/doc/assets/example-notched-end.jpeg" width="300">

```dart
Scaffold(
   floatingActionButton: FloatingActionButton(
      //params
   ),
   floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
   bottomNavigationBar: AnimatedBottomNavigationBar(
      icons: iconList,
      activeIndex: _bottomNavIndex,
      gapLocation: GapLocation.center,
      notchSmoothness: NotchSmoothness.defaultEdge,
      onTap: (index) => setState(() => _bottomNavIndex = index),
      //other params
   ),
);
```
<img src="https://raw.githubusercontent.com/LanarsInc/animated-bottom-navigation-bar-flutter/master/doc/assets/example-default-notch-center.jpeg" width="300">

```dart
Scaffold(
   floatingActionButton: FloatingActionButton(
      //params
   ),
   floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
   bottomNavigationBar: AnimatedBottomNavigationBar(
      icons: iconList,
      activeIndex: _bottomNavIndex,
      gapLocation: GapLocation.center,
      notchSmoothness: NotchSmoothness.softEdge,
      onTap: (index) => setState(() => _bottomNavIndex = index),
      //other params
   ),
);
```
<img src="https://raw.githubusercontent.com/LanarsInc/animated-bottom-navigation-bar-flutter/master/doc/assets/example-soft-notch-center.jpeg" width="300">

```dart
Scaffold(
   floatingActionButton: FloatingActionButton(
      //params
   ),
   floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
   bottomNavigationBar: AnimatedBottomNavigationBar(
      icons: iconList,
      activeIndex: _bottomNavIndex,
      gapLocation: GapLocation.center,
      notchSmoothness: NotchSmoothness.smoothEdge,
      onTap: (index) => setState(() => _bottomNavIndex = index),
      //other params
   ),
);
```
<img src="https://raw.githubusercontent.com/LanarsInc/animated-bottom-navigation-bar-flutter/master/doc/assets/example-smooth-notch-center.jpeg" width="300">

```dart
Scaffold(
   floatingActionButton: FloatingActionButton(
      //params
   ),
   floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
   bottomNavigationBar: AnimatedBottomNavigationBar(
      icons: iconList,
      activeIndex: _bottomNavIndex,
      gapLocation: GapLocation.center,
      notchSmoothness: NotchSmoothness.verySmoothEdge,
      onTap: (index) => setState(() => _bottomNavIndex = index),
      //other params
   ),
);
```
<img src="https://raw.githubusercontent.com/LanarsInc/animated-bottom-navigation-bar-flutter/master/doc/assets/example-very-smooth-notch-center.jpeg" width="300"> 

# Driving Navigation Bar Changes

You have to change the active navigation bar tab programmatically by passing a new activeIndex to the AnimatedBottomNavigationBar widget.

```dart
class _MyAppState extends State<MyApp> {
  int activeIndex;

  /// Handler for when you want to programmatically change
  /// the active index. Calling `setState()` here causes
  /// Flutter to re-render the tree, which `AnimatedBottomNavigationBar`
  /// responds to by running its normal animation.
  void _onTap(int index) {
    setState((){
      activeIndex = index;
    });
  }

  Widget build(BuildContext context) {
    return AnimatedBottomNavigationBar(
      activeIndex: activeIndex,
      onTap: _onTap,
      //other params
    );
  }
}
```