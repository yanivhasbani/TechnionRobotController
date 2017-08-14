# RoboCom
## An iOS app for robot controlling build on top of the UDP protocol.

## Installation:
In your terminal/console, write the following:

git clone https://github.com/yanivhasbani/TechnionRobotController.git

## Usage:

In order to use this, we assume that the endpoint this app should control has implemented our JSON based protocol.

- Enter the **robot IP address**, **robot UDP port number** and the **frequency (in miliseconds)** in which you want to send your messages.

## Communication protocol
Our communication protocol is JSON based, with the following implemantation:

#### App to robot example
```
{
  "message" : "Stop",
  "ipAddress" : "10.0.0.64"
}
```
**message** - one of the following options: "Stop", "Up", "Down", "Left", "Right"
**IPAddress** -  The IPAddress of the App

#### Robot to app

The app should be able to receive the following kind of message and present the current state over the map screen.

```
{
  "myLocation" : {
    "satelliteNumber" : 2,
    "coordinates" : {
      "x" : 2,
      "y" : 3,
      "degree": 3.14
    },
    "data" : {
      "motorSpeed" : 200
    }
  },
  "otherLocations" : [
    {
      "satelliteNumber" : 3,
      "coordinates" : {
        "x" : 5,
        "y" : 3,
        "degree": 1.57
      },
      "data" : {
        "lanceAngle" : 3.14
      }
    },
    {
      "satelliteNumber" : 6,
      "coordinates" : {
        "x" : 1,
        "y" : 1,
        "degree": 0
      },
      "data" : {
      }
    }
  ]
}
```

* **myLocation** - An object that will represent the satellite that is currently controlling. Built of:
  * **sateliteNumber** – the number of currently controlled satellite. 
  * **coordinates** – An object of coordinates off this satellite. Built of:
    * **x** - The position on the X axis 
    * **y** - The position on the Y axis 
    * **degree** - The degree, in radians, of rotation the satellite currently has. 
* **otherLocations** - an array of location objects. (See MyLocation for further info).
