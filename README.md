# Flutter Gantt Chart

This is a demonstration of gantt chart i.e. a work tracker with estimated deadline showing how much work is completed in a given time. The App is built only using flutter pre-defined widgets. App is tested on both Android and iOS.

# Getting Started with App

1. Download Android Studio and install flutter and dart. (See docs at https://docs.flutter.dev/get-started/install?gclid=CjwKCAiA9qKbBhAzEiwAS4yeDWF4xMRxNFWMZHXVGGlOfmehkvG8tTkGludRiBzrqfyeF_a70bU7oxoCnw4QAvD_BwE&gclsrc=aw.ds)
2. Download Postman for testing API (See docs at https://learning.postman.com/docs/getting-started/installation-and-updates/)
3. Create a Account at https://www.themoviedb.org/ and Sign to generate an API Key
4. Clone https://github.com/Ashwin1002/Movie_App in Android Studio
5. Install Emulator or use a mobile phone for testing
6. Run Flutter pub get for running the app

# About App

The App is divided into three components: Header Widget, Date Difference & Child Widget.

Header widget indicates the parent task which includes start date and end date and estimated time for task to be completed. Using Stack, the color represents how much task is completed. Date Widget shows the no. of days in date format between start date and end date. The smaller rounded container shows the child widget which may also contain its own sub-child. The sub- child widget has its own progress represented by color and task name.

# Screenshots

<table>
  <tr>
    <td>Index Page SS 1</td>
  </tr>
  <tr>
    <td><img src="https://user-images.githubusercontent.com/47735067/224262565-4b61cdc2-bf33-4c41-8989-595071030d51.png" width=270 height=550></td>
  </tr>


